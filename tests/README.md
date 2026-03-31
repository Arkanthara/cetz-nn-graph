# Tests

These Typst files show each API with code on the left and the rendered output on the right.
Arrow tests include grouped side distribution coverage for both default spreading and
`auto-distribute: false` behavior.
Defaults tests are grouped in a dedicated suite and include explicit `from-outer: true`
scenarios for stacked/image-stacked nodes so edge anchoring remains visually clear.

## Render the tests

```sh
bash scripts/render-tests.sh
```

A single PDF report is written to `tests/output/tests.pdf`.
