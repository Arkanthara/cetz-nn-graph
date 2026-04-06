= NN Graph Library

#import "@preview/cetz:0.4.2": canvas, draw
#import "../lib.typ": *

#set heading(numbering: "1.")
#outline(title: [Table of Contents], depth: 3)

== Quick start

```typ
#import "@preview/neural-viz:0.1.0": *

#graph-canvas({
  let ds = make-dataset("Image\nDataset", pos: (1.0, 0.0))
  let enc = make-trapezoid("Feature\nEncoder", subtitle: "Conv stack", after: ds, gap: 1.2)
  let head = make-box("Head", subtitle: "Prediction", after: enc, gap: 1.2)

  let nodes = (ds, enc, head)
  let arrows = (
    make-arrow(ds, enc, from-outer: true, label: [input]),
    make-arrow(enc, head, label: [features]),
  )
  draw-graph(nodes: nodes, arrows: arrows)
})
```

Rendered output:
#graph-canvas({
  let ds = make-dataset("Image\nDataset", pos: (1.0, 0.0))
  let enc = make-trapezoid("Feature\nEncoder", subtitle: "Conv stack", after: ds, gap: 1.2)
  let head = make-box("Head", subtitle: "Prediction", after: enc, gap: 1.2)

  let nodes = (ds, enc, head)
  let arrows = (
    make-arrow(ds, enc, from-outer: true, label: [input]),
    make-arrow(enc, head, label: [features]),
  )
  draw-graph(nodes: nodes, arrows: arrows)
})

== Helpers

=== `graph-canvas(body, length: 0.72cm)`
Wraps a CeTZ canvas and imports `draw` for you.

```typ
#graph-canvas({
  let ds = make-dataset("Dataset", pos: (1.0, 0.0))
  draw-node(ds)
})
```

=== `draw-nodes(nodes)` and `draw-graph(nodes, arrows, auto-distribute: true)`
Draws many nodes and arrows with one call.

```typ
#graph-canvas({
  let a = make-box("A", pos: (1.0, 0.0))
  let b = make-box("B", after: a, gap: 1.2)
  let c = make-box("C", pos: (3.8, -1.8))

  let nodes = (a, b, c)
  let arrows = (
    make-arrow(a, b, label: [main]),
    make-arrow(c, b, in-side: "bottom", label: [aux]),
  )
  draw-graph(nodes: nodes, arrows: arrows)
})
```

== Nodes

=== `make-dataset(...)`
Creates a stacked image node.

```typ
#let ds = make-dataset(
  "Image\nDataset",
  images: 3,
  image-size: (1.9, 2.3),
  image-spacing: 0.22,
  title-position: "inside",
  pos: (1.0, 0.0),
)
```

=== `make-trapezoid(...)`
Creates encoder and decoder trapezoids.

```typ
#let enc = make-trapezoid(
  "Encoder",
  subtitle: "Downsample",
  mode: "encoder",
  width: 2.8,
  big-half: 1.65,
  small-half: 0.80,
  pos: (5.0, 0.0),
)
```

=== `make-box(...)`
Creates rectangular processing blocks with optional auto sizing.

```typ
#let b = make-box(
  "Classifier",
  subtitle: "MLP",
  size: none,
  pos: (8.0, 0.0),
)
```

=== `make-image-node(...)`
Creates a single-image node. Image content is auto-scaled and cropped to the
target frame so node geometry and positioning stay consistent. Use
`image-shift-x` and `image-shift-y` to pan the crop window inside the frame.
Use values in the `-1` to `1` range, where `0` keeps the image centered.
Positive `image-shift-x` moves the image to the right; positive
`image-shift-y` moves it downward.
This behavior is consistent for both `src:` file images and prebuilt `img:` content.

```typ
#let img = make-image-node(
  "Input",
  src: "/assets/test.jpg",
  image-width: 2.2,
  image-height: 2.2,
  image-pad: 0.08,
  image-shift-x: 0.25,
  image-shift-y: -0.1,
  unit: 0.72cm,
  title-position: "below",
  pos: (1.0, 0.0),
)
```

=== `make-image-dataset(...)`
Creates a stacked dataset node that reuses the same fitted image on every layer.
The same crop-shift options apply here as well.

```typ
#let ds = make-image-dataset(
  "Image\nDataset",
  src: "/assets/test.jpg",
  images: 4,
  image-width: 1.6,
  image-height: 2.1,
  image-spacing: 0.16,
  image-pad: 0.08,
  image-shift-x: -0.2,
  unit: 0.72cm,
  title-position: "below",
  pos: (3.8, 0.0),
)
```

=== `make-latent-space(...)`
Creates a tall, narrow latent-space block (default width is `0.7`).

```typ
#let latent = make-latent-space(
  "Latent\nSpace",
  height: 3.1,
  pos: (6.8, 0.0),
)
```

Note: If you override `graph-canvas(length: ...)`, pass the same value to `unit` in image
constructors so the image sizing matches the canvas.

Tip: Prefer `src: "/path/to/file"` for automatic scaling/cropping directly in the
node constructor. Use `img: image("/path/to/file")` if you need custom image
styling first; it is auto-fit to the requested size as well.
You can specify size with either `image-size: (w, h)` or
`image-width: w, image-height: h`.

== Arrows

=== `make-arrow(...)`, `draw-arrow(...)`, and `draw-arrows(...)`
Builds orthogonal routes between nodes and renders one arrow or a grouped tuple.

```typ
#graph-canvas({
  let up = make-box("Up", pos: (1.0, 1.2))
  let down = make-box("Down", pos: (1.0, -1.2))
  let target = make-dataset("Embed", images: 2, image-size: (1.2, 1.5), pos: (5.0, 0.0))

  draw-node(up)
  draw-node(down)
  draw-node(target)

  let a = make-arrow(up, target, out-side: "right", in-side: "left", label: [a])
  draw-arrow(a)

  let grouped = (
    make-arrow(up, target, out-side: "right", in-side: "left", label: [a]),
    make-arrow(down, target, out-side: "right", in-side: "left", label: [b]),
  )
  draw-arrows(grouped)
})
```

`make-arrow` accepts one endpoint ordering control:
- `order`: explicit rank used for both source and destination endpoints.

Lower values are placed first. If two arrows share the same order value, the
arrow that appears first in code is placed first.

Routing tip: You can keep automatic routing while constraining one segment
length with `mode-shift: (i, len)`.
- `i` is 1-based.
- `i = 0` or `i = -1` targets the last segment.
- Unspecified segments remain automatic.

Routing controls overview:
- `mode`: a string made of `h` and `v` (for example `hv`, `vh`, `hvh`, `vhvh`, `hvhvh`).
- `mode-shift`: one override tuple `(i, len)`.
- `mode-shifts`: multiple overrides with two accepted forms.

`mode-shifts` form A (positional lengths):
- Example: `mode: "vhvh", mode-shifts: (none, 1.2, none, 0.8)`.
- Entry `k` controls segment `k`.
- Use `none` to keep that segment automatic.

`mode-shifts` form B (indexed overrides):
- Example: `mode: "vhvh", mode-shifts: ((1, 1.0), (-1, 0.8))`.
- First value is segment index, second value is fixed length.
- Supports positive indices, `0`, and negative-from-end indices.

Precedence:
- If `mode-shifts` is provided, it takes precedence.
- `mode-shift` is used only when `mode-shifts` is not provided.

```typ
#let feedback = make-arrow(
  dec,
  enc,
  out-side: "bottom",
  in-side: "left",
  mode: "vhvh",
  mode-shift: (0, 1.0),
)
```

```typ
#let feedback2 = make-arrow(
  dec,
  enc,
  out-side: "top",
  in-side: "left",
  mode: "vhvh",
  mode-shifts: ((1, 1.0), (-1, 0.8)),
)
```

```typ
#graph-canvas({
  let a = make-box("A", pos: (1.0, 1.4))
  let b = make-box("B", pos: (1.0, -1.4))
  let target = make-box("Target", pos: (6.0, 0.0))

  draw-nodes((a, b, target))

  let arrows = (
    // Left side ordering is top-to-bottom.
    make-arrow(a, target, in-side: "left", order: 2, label: [second]),
    make-arrow(b, target, in-side: "left", order: 1, label: [first]),
  )
  draw-arrows(arrows)
})
```

Tip: Use `draw-arrows((...))` when several arrows share one node side. Anchors
for both incoming and outgoing endpoints are spread evenly along that side by
default. Set
`draw-arrows(arrows, auto-distribute: false)` to disable this behavior.

== Emoji markers

=== `draw-node-emoji(...)`
Adds lock, key, or custom emoji near a node.

```typ
#draw-node-emoji(enc, kind: "lock-open", place: "top")
```

== Defaults

=== `set-* -defaults(...)`
Returns preconfigured constructors with your preferred defaults.

```typ
#let make-dataset = set-dataset-defaults(options: (images: 4, image-spacing: 0.18))
#let make-image-node = set-image-node-defaults(options: (image-width: 2.0, image-height: 2.0, title-position: "below"))
#let make-image-dataset = set-image-dataset-defaults(options: (images: 4, image-width: 1.6, image-height: 2.1, title-position: "below"))
#let make-latent-space = set-latent-space-defaults(options: (width: 0.8, height: 3.0, title-position: "below"))
#let make-arrow = set-arrow-defaults(options: (spacing: 0.5, label-gap: 0.35))
```

== Example: Autoencoder

#graph-canvas({
  let input = make-image-dataset(
    "Input\nImages",
    src: "/assets/test.jpg",
    images: 3,
    image-width: 1.9,
    image-height: 2.3,
    image-spacing: 0.22,
    image-pad: 0.08,
    unit: 0.72cm,
    title-position: "below",
    pos: (1.0, 0.0),
  )
  let enc = make-trapezoid("Encoder", subtitle: "Downsample", after: input, gap: 1.2)
  let latent = make-latent-space(
    "Latent\nSpace",
    height: 3.0,
    after: enc,
    gap: 1.2,
  )
  let dec = make-trapezoid("Decoder", subtitle: "Upsample", mode: "decoder", after: latent, gap: 1.2)
  let output = make-image-dataset(
    "Reconstruction",
    src: "/assets/test.jpg",
    images: 3,
    image-width: 1.9,
    image-height: 2.3,
    image-spacing: 0.22,
    image-pad: 0.08,
    unit: 0.72cm,
    title-position: "below",
    after: dec,
    gap: 1.2,
  )

  draw-node(input)
  draw-node(enc)
  draw-node(latent)
  draw-node(dec)
  draw-node(output)

  let arrows = (
    make-arrow(input, enc, from-outer: true, label: [input]),
    make-arrow(enc, latent, label: [encode]),
    make-arrow(latent, dec, label: [decode]),
    make-arrow(dec, output, from-outer: true, label: [output]),
  )
  draw-arrows(arrows)
})
