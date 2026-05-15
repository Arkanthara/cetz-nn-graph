# Tests

The suite is Fletcher-first and has three layers:

- Unit assertions for specs, nodes, positioning, and layout.
- Integration diagrams for complete ML workflows.
- Visual smoke diagrams compiled to PDF/SVG by CI.

## Render the tests

```sh
bash scripts/render-tests.sh
```

A single PDF report is written to `tests/output/tests.pdf`.
