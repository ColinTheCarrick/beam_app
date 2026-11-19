# Validation

Store hand calculations and test cases in this folder. Run the calculation
checks from the repository root with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\02_validation\validate.ps1
```

The current checks use synthetic demo properties to verify calculation
behavior only; they do not validate real beam properties or structural design.
