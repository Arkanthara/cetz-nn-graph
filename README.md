# neural-viz

Fletcher-first Typst diagrams for machine-learning systems: pipelines, model
architectures, encoder/decoder flows, transformers, multimodal systems,
training loops, inference paths, datasets, tensors, embeddings, and production
ML workflows.

The library was rewritten around Fletcher. It no longer exposes a CeTZ drawing
backend. ML abstractions describe nodes, layouts assign Fletcher coordinates,
and rendering delegates nodes, anchors, labels, arrow marks, groups, and routing
to Fletcher.

## Install

```typ
#import "@preview/neural-viz:0.2.0": *
```

The code imports Fletcher `0.5.8` from the Typst preview registry. If you need
Fletcher directly in your document, you can import it explicitly:

```typ
#import "@preview/fletcher:0.5.8"
```

## Quick Start

```typ
#import "@preview/neural-viz:0.2.0": *

#let nodes = (
  dataset("images", title: [Image dataset]),
  encoder("encoder", title: [Feature encoder], subtitle: [Conv stack]),
  module("head", title: [Head], subtitle: [Prediction]),
)

#let edges = (
  ml-edge("images", "encoder", label: [input]),
  ml-edge("encoder", "head", label: [features]),
)

#ml-diagram(nodes, edges: edges, layout: "pipeline")
```

## Public API

Core:

- `ml-node`, `ml-edge`, `ml-diagram`
- `layout-pipeline`, `layout-dag`, `layout-grid`, `apply-layout`
- `right-of`, `left-of`, `above`, `below`, `offset-pos`, `anchor-ref`

ML nodes:

- Data: `dataset`, `batch`, `tensor`, `vector`, `embedding`
- Images: `image-node`, `image-dataset`
- Components: `module`, `operation`, `layer`, `encoder`, `decoder`,
  `attention`, `transformer`, `io-node`, `decision`
- Composition: `group`

Migration shims:

- `make-dataset`, `make-image-node`, `make-image-dataset`
- `make-trapezoid`, `make-box`, `make-square`, `make-circle`, `make-text`
- `make-arrow`, `draw-graph`, `graph-canvas`

## Layout

`ml-diagram` accepts:

- `layout: "pipeline"` for sequential ML flows.
- `layout: "dag"` for deterministic rank layout from edges.
- `layout: "grid"` for compact module grids.
- `layout: false` to keep explicit and Fletcher-relative positions.
- A custom function `(nodes, edges: edges) => nodes`.

Manual and automatic placement can be mixed. Nodes with explicit `pos` are
preserved by default; nodes with `pos: auto` are placed by the layout.

## Examples

Generate SVG examples:

```sh
bash scripts/render-examples.sh
```

Gallery sources live in `examples/`:

- `quickstart.typ`
- `autoencoder.typ`
- `classifier.typ`
- `segmentation.typ`
- `siamese.typ`
- `gan.typ`
- `image-nodes.typ`

## Tests

Run the full test report:

```sh
bash scripts/render-tests.sh
```

The suite includes unit assertions for core specs, positioning, layouts and ML
nodes; integration diagrams for full workflows; and visual smoke fixtures.

## Documentation

- `docs/guide.typ`: user guide and API walkthrough.
- `docs/migration.md`: migration from the old CeTZ-based API.
- `docs/advanced.md`: layout, grouping, and Fletcher integration notes.
- `tests/README.md`: test structure.

## Migration From CeTZ Version

This is not a mechanical port. The old constructors remain as compatibility
shims, but new diagrams should introduce stable node ids and use Fletcher-native
coordinates:

```typ
// Old style
#let enc = make-trapezoid("Encoder", after: input)

// New style
#let enc = encoder("enc", title: [Encoder], pos: right-of("input"))
```

Use `group(...)` instead of manual background boxes, `from-side`/`to-side`
instead of hand-computed anchors, and `layout-dag`/`layout-pipeline` instead of
manual coordinate propagation.
