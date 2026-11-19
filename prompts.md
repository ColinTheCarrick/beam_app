# Prompts

- **Asked:** Set up the single-file web app project layout with numbered folders and folder guidance.
  **Changed:** Added the requested root files and folder READMEs, and documented the layout and file-placement rule in `AGENTS.md`.
  **Worked:** Yes; the requested structure is in place. No app features were built.
- **Asked:** Review the initial beam-app specification and suggest improvements, especially real-beam properties; do not write code.
  **Changed:** Reviewed `spec.md` and provided recommendations only; no code or specification changes.
  **Worked:** Yes; recommendations were provided without implementing the app.
- **Asked:** Add the review recommendations to `spec.md`.
  **Changed:** Expanded the specification with MVP scope, steel section properties and sources, units and assumptions, qualified checks, outputs, and validation cases.
  **Worked:** Yes; updated documentation only, with no application code.
- **Asked:** Suggest next steps for the beam app project.
  **Changed:** Recommended a prioritized sequence for resolving design assumptions, sourcing beam data, validating calculations, and then implementing the MVP.
  **Worked:** Yes; provided guidance only, with no application code.
- **Asked:** Proceed with the next steps; use made-up beam properties for now and stop web research.
  **Changed:** Added a single-file beam analysis prototype, explicitly synthetic shape data, hand-check cases, a repeatable calculation validation script, and updated the specification with the agreed preliminary-check assumptions.
  **Worked:** Yes; all three calculation cases passed, the app scripts parsed, HTML/JSON checks passed, and local static hosting served the app and data. Section properties remain explicitly synthetic.
- **Asked:** Separate overlapping point-load and distributed-load labels in the beam diagram.
  **Changed:** Put point-load and uniform-load annotations on distinct horizontal rows and added a gap in the distributed-load graphic around point loads.
  **Worked:** Yes; reproduced the overlap in the browser, then verified the labels and arrows are separated after the change.
- **Asked:** Change span, load, and load-position inputs to sliders.
  **Changed:** Added a 0-100 ft span slider, signed point/uniform load sliders, position sliders limited to the current span, live value readouts, and documented the ranges in `spec.md`.
  **Worked:** Yes; browser checks confirmed bounds, readouts, span clamping, and zero-span validation; all three calculation regression cases passed.
- **Asked:** Add a top dropdown for color schemes, including dark mode, night mode, and fun options.
  **Changed:** Added a header theme selector and themed the page controls, panels, notices, and analysis diagrams.
  **Worked:** Yes; browser checks confirmed all six themes update page, panel, text, diagram arrow, and browser theme colors. Mobile layout has no horizontal overflow, and all three calculation regression cases passed.
