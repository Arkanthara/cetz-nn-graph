# Tests

These Typst files show each API with code on the left and the rendered output on the right.
Arrow tests include grouped side distribution coverage for both default spreading and
`auto-distribute: false` behavior, including mixed incoming/outgoing endpoints on the
same node side. They also cover explicit endpoint ordering (`order`)
and code-order tie breaking when two arrows share the same order value.
Defaults tests are grouped in a dedicated suite and include explicit `from-outer: true`
scenarios for stacked/image-stacked nodes so edge anchoring remains visually clear.

## Render the tests

```sh
bash scripts/render-tests.sh
```

A single PDF report is written to `tests/output/tests.pdf`.
