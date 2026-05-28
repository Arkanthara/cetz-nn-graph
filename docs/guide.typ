= Neural Viz Guide

#import "../lib.typ": *

#set heading(numbering: "1.")
#outline(title: [Table of Contents], depth: 3)

== Philosophy

`neural-viz` is now a Fletcher-first Typst library. Nodes are lightweight ML
specifications, layouts assign Fletcher coordinates, and rendering delegates
nodes, groups, anchors, labels, marks, and routing to Fletcher.

The old CeTZ canvas layer has been removed from the public architecture. Legacy
constructors such as `make-box` and `make-arrow` are still available as migration
shims, but new documents should prefer `dataset`, `encoder`, `ml-edge`, and
`ml-diagram`.

== Quick Start

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

#let quick-nodes = (
  dataset("images", title: [Image dataset]),
  encoder("encoder", title: [Feature encoder], subtitle: [Conv stack]),
  module("head", title: [Head], subtitle: [Prediction]),
)
#let quick-edges = (
  ml-edge("images", "encoder", label: [input]),
  ml-edge("encoder", "head", label: [features]),
)
#ml-diagram(quick-nodes, edges: quick-edges, layout: "pipeline")

== Core API

=== Nodes

Every node has a stable string id. Edges and relative positions refer to ids.

```typ
#let x = tensor("features", title: [Feature tensor], dims: [$B times C times H times W$])
#let y = transformer("block", title: [Transformer block], pos: right-of("features"))
```

Useful constructors:

- `dataset`, `batch`, `tensor`, `vector`, `embedding`
- `image-node`, `image-dataset`
- `table-node`, `table-cell`
- `module`, `operation`, `layer`
- `encoder`, `decoder`, `attention`, `transformer`
- `io-node`, `decision`
- `group`

=== Edges

`ml-edge(from, to, ...)` is a thin ML wrapper over `fletcher.edge`. It keeps
semantic fields such as `kind` while forwarding labels, marks, bends, anchors,
crossing settings, and styling to Fletcher.

```typ
#ml-edge("encoder", "head", label: [features])
#ml-edge("skip", "decoder", from-side: "bottom", to-side: "top", bend: 25deg)
```

=== Diagrams

`ml-diagram(nodes, edges: edges, layout: "dag")` resolves layout first, then
renders a Fletcher `diagram`.

Layouts:

- `"pipeline"`: sequential left-to-right flow.
- `"dag"`: deterministic rank layout from edges.
- `"grid"`: row/column placement.
- `false` or `none`: keep all manual and Fletcher-relative positions.
- function: custom layout `(nodes, edges: edges) => nodes`.

== Positioning

You can mix automatic and manual positioning. A node with `pos: auto` is placed
by the selected layout. A node with explicit `pos` is preserved.

```typ
#let nodes = (
  dataset("input", title: [Input], pos: (0, 0)),
  encoder("enc", title: [Encoder]),          // placed by layout
  attention("attn", title: [Attention], pos: right-of("enc", dy: -0.75)),
)
```

Helpers:

- `right-of(ref, by: 1, dy: 0)`
- `left-of(ref, by: 1, dy: 0)`
- `above(ref, by: 1, dx: 0)`
- `below(ref, by: 1, dx: 0)`
- `offset-pos(pos, by: (dx, dy))`
- `anchor-ref(ref, side: "right")`

The helpers return Fletcher coordinate expressions or anchor labels, so routing
and snapping remain native Fletcher behavior.

== Groups

Groups use Fletcher `enclose` natively.

```typ
#let g = group("encoders", ("vision", "language"), title: [Encoders])
```

#let group-nodes = (
  dataset("images", title: [Images]),
  dataset("text", title: [Tokens]),
  encoder("vision", title: [Vision encoder]),
  encoder("language", title: [Text encoder]),
  transformer("fusion", title: [Fusion transformer]),
  io-node("answer", title: [Answer]),
  group("encoders", ("vision", "language"), title: [Encoders]),
)
#let group-edges = (
  ml-edge("images", "vision"),
  ml-edge("text", "language"),
  ml-edge("vision", "fusion"),
  ml-edge("language", "fusion"),
  ml-edge("fusion", "answer"),
)
#ml-diagram(group-nodes, edges: group-edges, layout: "dag")

== Images

Image nodes use Typst content inside Fletcher nodes.

```typ
#image-node("sample", title: [Sample], src: "/assets/test.jpg")
#image-dataset("train", title: [Training set], src: "/assets/test.jpg", stack: 4)
```

== Tables

Table nodes render grid-style blocks with per-cell content. Use `table-cell` to
override alignment, padding, or styling on a single cell.

```typ
#let cells = (
  (
    table-cell([Class], align: left + horizon, inset: 3pt),
    table-cell(text(size: 0.72em)[Cat]),
    table-cell(text(size: 0.72em)[Dog]),
  ),
  ([Precision], [0.91], [0.88]),
  ([Recall], [0.87], [0.90]),
)

#table-node(
  "metrics",
  title: [Metrics],
  rows: 3,
  columns: 3,
  cells: cells,
  column-widths: (1.6, 1.0, 1.0),
  row-heights: (0.6, 0.6, 0.6),
  cell-inset: 2pt,
)
```

Shift all cell content at once (useful for visually centering glyphs with
descenders like `p` or `g`):

```typ
#table-node(
  "glyph",
  rows: 1,
  columns: 1,
  cells: ([p],),
  cell-aligns: (center + horizon,),
  cell-shift: (0pt, -1pt),
)
```

Change text size globally or per cell:

```typ
#table-node(
  "sizes",
  rows: 1,
  columns: 3,
  cells: ([a], [b], [c]),
  cell-text-size: 1.2em,
  cell-text-sizes: (0.9em, 1.2em, 1.6em),
)
```

Shift entire rows or columns with a single list of offsets:

```typ
#table-node(
  "shifted",
  rows: 2,
  columns: 3,
  cells: ([p], [q], [b], [d], [e], [f]),
  cell-aligns: (center + horizon, center + horizon, center + horizon,
                center + horizon, center + horizon, center + horizon),
  cell-text-size: 1.4em,
  cell-shift: (0em, -0.3em),
  row-shifts: ((0em, 0em), (0em, 0.4em)),
  column-shifts: ((-0.2em, 0em), (0em, 0em), (0.2em, 0em)),
)
```

Shortcuts for per-cell alignment and offsets (same row-major shape as `cells`):

```typ
#let letters = (
  ("A", "B", "C"),
  ("D", "E", "F"),
)

#let aligns = (
  (left + top, center + top, right + top),
  (left + bottom, center + horizon, right + bottom),
)

#let offsets = (
  ((-2pt, -1pt), (0pt, -1pt), (2pt, -1pt)),
  ((-2pt, 1pt), (0pt, 0pt), (2pt, 1pt)),
)

#table-node(
  "letters",
  rows: 2,
  columns: 3,
  cells: letters,
  cell-aligns: aligns,
  cell-offsets: offsets,
  cell-size: (1.1, 0.7),
)
```

You can also pass flat row-major lists for overrides (length = rows * columns).

== Migration

The old functions are available but implemented on top of the new Fletcher
backend:

- `make-dataset` -> `dataset`
- `make-image-node` -> `image-node`
- `make-image-dataset` -> `image-dataset`
- `make-trapezoid(mode: "encoder")` -> `encoder`
- `make-trapezoid(mode: "decoder")` -> `decoder`
- `make-box` -> `module`
- `make-arrow` -> `ml-edge`
- `draw-graph` -> `ml-diagram`

Recommended migration is conceptual rather than mechanical: introduce ids,
replace manual CeTZ coordinates with Fletcher-relative helpers where possible,
and let `ml-diagram` own the layout.
