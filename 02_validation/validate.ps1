$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$htmlPath = Join-Path $repositoryRoot 'index.html'
$dataPath = Join-Path (Join-Path $repositoryRoot '01_data') 'w_shapes.json'
$casesPath = Join-Path $PSScriptRoot 'beam_cases.json'

$html = Get-Content -Raw -LiteralPath $htmlPath
$scriptMatch = [regex]::Match($html, '(?s)<script id="beam-engine">(.+?)</script>')
if (-not $scriptMatch.Success) {
    throw 'Could not find the beam calculation script in index.html.'
}
$uiScriptMatch = [regex]::Match($html, '(?s)<script>(.+?)</script>')
if (-not $uiScriptMatch.Success) {
    throw 'Could not find the app UI script in index.html.'
}

$dataset = Get-Content -Raw -LiteralPath $dataPath | ConvertFrom-Json
$section = $dataset.sections | Where-Object { $_.id -eq 'demo-w12x26' } | Select-Object -First 1
if (-not $section) {
    throw 'The demo section is missing from 01_data/w_shapes.json.'
}

$validation = Get-Content -Raw -LiteralPath $casesPath | ConvertFrom-Json
$testCases = @()
foreach ($case in $validation.cases) {
    $testCases += [pscustomobject]@{
        id = $case.id
        config = [pscustomobject]@{
            spanFt = [double]$case.input.spanFt
            supportType = [string]$case.input.supportType
            Eksi = [double]$dataset.material.elasticModulusKsi
            IxIn4 = [double]$section.IxIn4
            pointLoads = @($case.input.pointLoads)
            distributedLoads = @($case.input.distributedLoads)
        }
        expected = $case.expected
    }
}

$casesJson = ConvertTo-Json -InputObject $testCases -Depth 10 -Compress
$toleranceJson = ConvertTo-Json -InputObject $validation.tolerance -Depth 5 -Compress
$testScript = @"
$($scriptMatch.Groups[1].Value)
$($uiScriptMatch.Groups[1].Value)

var validationCases = $casesJson;
var validationTolerance = $toleranceJson;
var failures = 0;
function assertNear(label, actual, expected, tolerance) {
    if (Math.abs(actual - expected) > tolerance) {
        WScript.Echo("FAIL " + label + ": expected " + expected + ", got " + actual);
        failures++;
    }
}
for (var i = 0; i < validationCases.length; i++) {
    var testCase = validationCases[i];
    var result = calculateBeam(testCase.config);
    var expected = testCase.expected;
    var prefix = testCase.id + " ";
    assertNear(prefix + "left reaction", result.leftReactionKip, expected.leftReactionKip, validationTolerance.reactionsKip);
    assertNear(prefix + "right reaction", result.rightReactionKip, expected.rightReactionKip, validationTolerance.reactionsKip);
    assertNear(prefix + "maximum shear", result.maxShearAbsKip, expected.maxShearAbsKip, validationTolerance.shearKip);
    assertNear(prefix + "maximum moment", result.maxMomentAbsKipFt, expected.maxMomentAbsKipFt, validationTolerance.momentKipFt);
    assertNear(prefix + "maximum moment location", result.maxMomentLocationFt, expected.maxMomentLocationFt, validationTolerance.locationFt);
    assertNear(prefix + "maximum deflection", result.maxDeflectionAbsIn, expected.maxDeflectionAbsIn, validationTolerance.deflectionIn);
    assertNear(prefix + "maximum deflection location", result.maxDeflectionLocationFt, expected.maxDeflectionLocationFt, validationTolerance.locationFt);
    if (typeof expected.fixedEndReactionMomentKipFt !== "undefined") {
        assertNear(prefix + "fixed-end reaction moment", result.fixedEndReactionMomentKipFt, expected.fixedEndReactionMomentKipFt, validationTolerance.momentKipFt);
    }
}
if (failures > 0) {
    WScript.Echo(failures + " validation assertion(s) failed.");
    WScript.Quit(1);
}
WScript.Echo(validationCases.length + " beam validation cases passed.");
"@

$temporaryScript = Join-Path $env:TEMP (([IO.Path]::GetRandomFileName()) + '.js')
try {
    [IO.File]::WriteAllText($temporaryScript, $testScript, [Text.Encoding]::ASCII)
    $output = & cscript.exe //nologo $temporaryScript 2>&1
    $exitCode = $LASTEXITCODE
    $output | ForEach-Object { Write-Output $_ }
    if ($exitCode -ne 0) {
        throw "Beam validation failed with exit code $exitCode."
    }
}
finally {
    if (Test-Path -LiteralPath $temporaryScript) {
        Remove-Item -LiteralPath $temporaryScript
    }
}
