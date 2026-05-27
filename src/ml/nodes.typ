#import "../fletcher.typ": shapes
#import "../core/spec.typ": ml-node
#import "../core/utils.typ": default-unit, to-length, to-size, ensure-array, as-node-id
#import "../core/position.typ": node-ref

// ─── Palette ──────────────────────────────────────────────────────────────────

#let palette = (
  data:      rgb("#d7ecff"),
  image:     rgb("#fff7d6"),
  tensor:    rgb("#e5f4df"),
  module:    rgb("#e8e4ff"),
  operation: rgb("#f5e6d8"),
  encoder:   rgb("#dff2e1"),
  decoder:   rgb("#fde6d7"),
  attention: rgb("#f3def1"),
  output:    rgb("#e7ecef"),
  group:     rgb("#f7f7f7"),
)


// ═══════════════════════════════════════════════════════════════════════════════
// INTERNAL HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

// ─── Text label ───────────────────────────────────────────────────────────────
// Renders an optional badge (tiny), a bold title, and an optional subtitle.
// All sizes are controllable; pass `badge: none` (default) to suppress the badge.
#let _text-block(
  title,
  subtitle:      none,
  badge:         none,
  title-size:    0.92em,
  subtitle-size: 0.72em,
) = align(center)[
  #if badge != none [
    #text(size: 0.62em, fill: rgb("#5a6570"))[#badge]
    #linebreak()
  ]
  #text(size: title-size, weight: "semibold")[#title]
  #if subtitle != none [
    #linebreak()
    #text(size: subtitle-size, fill: rgb("#4f5b66"))[#subtitle]
  ]
]


// ─── Stack drawing ────────────────────────────────────────────────────────────
// Draws `count` overlapping rounded-rect copies.
// Front copy (i = count-1, rendered last = on top) sits at offset (0, 0).
// Each step further back adds (dx, dy) to the offset.
// An optional `label` is centered inside the front copy only.
#let _draw-stack(count, dx, dy, w, h, fill, stroke-clr, radius, label: none) = {
  let sk = (paint: stroke-clr, thickness: 0.7pt)
  let n  = calc.max(1, count)
  box(width: w + dx * (n - 1), height: h + dy * (n - 1))[
    #for i in range(n) {
      let is-front = (i == n - 1)
      place(
        left + top,
        dx: dx * (n - 1 - i),
        dy: dy * (n - 1 - i),
      )[
        #rect(width: w, height: h, fill: fill, stroke: sk, radius: radius)[
          #if is-front and label != none {
            align(center + horizon)[#label]
          }
        ]
      ]
    }
  ]
}


// ─── Shape drawing (for above / below label-pos) ──────────────────────────────
// Draws a single shape as a plain Typst element so that a text label can be
// positioned freely above or below it (outside the shape boundary).
// Supported kinds: "rect" | "pill" | "circle" | "diamond" |
//                  "trapezium-r" | "trapezium-l" | "hexagon"
#let _draw-shape(w, h, fill, stroke-clr, kind, label: none) = {
  let sk    = (paint: stroke-clr, thickness: 0.7pt)
  let inner = if label != none { align(center + horizon)[#label] } else { none }

  if kind == "pill" {
    rect(width: w, height: h, fill: fill, stroke: sk, radius: calc.min(w, h) / 2)[#inner]

  } else if kind == "circle" {
    circle(width: w, fill: fill, stroke: sk)[#inner]

  } else if kind == "diamond" {
    box(width: w, height: h)[
      #polygon(fill: fill, stroke: sk, (w / 2, 0pt), (w, h / 2), (w / 2, h), (0pt, h / 2))
      #if inner != none { place(center + horizon, inner) }
    ]

  } else if kind == "trapezium-r" {
    let a = h * calc.tan(18deg)
    box(width: w, height: h)[
      #polygon(fill: fill, stroke: sk, (0pt, 0pt), (w, a), (w, h - a), (0pt, h))
      #if inner != none { place(center + horizon, inner) }
    ]

  } else if kind == "trapezium-l" {
    let a = h * calc.tan(18deg)
    box(width: w, height: h)[
      #polygon(fill: fill, stroke: sk, (0pt, a), (w, 0pt), (w, h), (0pt, h - a))
      #if inner != none { place(center + horizon, inner) }
    ]

  } else if kind == "hexagon" {
    let d = w / 5
    box(width: w, height: h)[
      #polygon(fill: fill, stroke: sk,
               (d, 0pt), (w - d, 0pt), (w, h / 2), (w - d, h), (d, h), (0pt, h / 2))
      #if inner != none { place(center + horizon, inner) }
    ]

  } else {
    // "rect" (default)
    rect(width: w, height: h, fill: fill, stroke: sk, radius: 3pt)[#inner]
  }
}


// ─── Compose label and shape ──────────────────────────────────────────────────
// Stacks `shape-box` and `text-lbl` according to `pos`.
//   "above"  → text above shape
//   "below"  → text below shape
//   "inside" → returns shape-box as-is (label already embedded inside)
#let _compose(shape-box, text-lbl, pos, gap: 4pt) = {
  if pos == "above" {
    stack(dir: ttb, spacing: gap, text-lbl, shape-box)
  } else if pos == "below" {
    stack(dir: ttb, spacing: gap, shape-box, text-lbl)
  } else {
    shape-box   // "inside": label was embedded by _draw-stack / _draw-shape
  }
}


// ─── Image stack drawing ──────────────────────────────────────────────────────
// Like _draw-stack but every layer is a full-cover image box instead of a rect.
// The front copy (i = count-1, on top) sits at offset (0, 0); each step further
// back adds (dx, dy).  No label is embedded — place the caption outside via
// caption-pos in image-dataset.
#let _draw-image-stack(count, dx, dy, w, h, src, img, image-fit) = {
  let n = calc.max(1, count)
  box(width: w + dx * (n - 1), height: h + dy * (n - 1))[
    #for i in range(n) {
      place(
        left + top,
        dx: dx * (n - 1 - i),
        dy: dy * (n - 1 - i),
      )[
        #box(width: w, height: h, clip: true, inset: 0pt)[
          #if src != none {
            image(src, width: w, height: h, fit: image-fit)
          } else if img != none {
            box(width: w, height: h)[#img]
          } else {
            rect(width: w, height: h, fill: rgb("#d8dde0"), stroke: none)
          }
        ]
      ]
    }
  ]
}


// ─── Image helpers (unchanged) ────────────────────────────────────────────────
#let _image-box(src: none, img: none, width: 24mm, height: 18mm, fit: "cover") = {
  box(width: width, height: height, clip: true, inset: 0pt)[
    #if src != none {
      image(src, width: width, height: height, fit: fit)
    } else if img != none {
      box(width: width, height: height)[#img]
    } else {
      rect(width: width, height: height, fill: rgb("#eeeeee"), stroke: none)
    }
  ]
}

#let _image-label(
  title, subtitle: none,
  src: none, img: none,
  image-width: 24mm, image-height: 18mm, image-fit: "cover",
  title-size: 0.78em,
  subtitle-size: 0.64em,
  gap: 3pt,
) = stack(
  dir: ttb, spacing: gap,
  align(center)[
    #_image-box(src: src, img: img, width: image-width, height: image-height, fit: image-fit)
  ],
  _text-block(title, subtitle: subtitle, title-size: title-size, subtitle-size: subtitle-size),
)


// ═══════════════════════════════════════════════════════════════════════════════
// DATA NODES  (dataset · batch · tensor · vector · embedding)
// ═══════════════════════════════════════════════════════════════════════════════

// ─── dataset ──────────────────────────────────────────────────────────────────
// A rectangular stacked node representing a data collection.
//
// Parameters
// ──────────
//   samples    Content shown as badge (e.g. [256 samples]).  none = no badge.
//   stack      Number of layered copies (1 = single rect, no depth).
//   stack-dx   Horizontal offset per layer  (default 2pt).
//   stack-dy   Vertical offset per layer    (default 2pt).
//   label-pos  "inside" | "above" | "below"
//   title-size / subtitle-size  Control font sizes.
//   title-gap  Spacing between label and shape when label-pos is above/below.
#let dataset(
  id,
  title:         auto,
  subtitle:      none,
  samples:       none,
  pos:           auto,
  after:         none,
  offset:        (0, 0),
  size:          (2.1, 1.45),
  unit:          default-unit,
  fill:          palette.data,
  stroke:        rgb("#384655"),
  stack:         3,
  stack-dx:      2pt,
  stack-dy:      2pt,
  label-pos:     "inside",
  title-size:    0.92em,
  subtitle-size: 0.72em,
  title-gap:     4pt,
  ..options,
) = {
  let title    = if title == auto { id } else { title }
  let (w, h)   = to-size(size, unit: unit)
  let text-lbl = _text-block(title, subtitle: subtitle, badge: samples,
                              title-size: title-size, subtitle-size: subtitle-size)

  let label = if label-pos == "inside" {
    _draw-stack(stack, stack-dx, stack-dy, w, h, fill, stroke, 3pt, label: text-lbl)
  } else {
    let shape = _draw-stack(stack, stack-dx, stack-dy, w, h, fill, stroke, 3pt)
    _compose(shape, text-lbl, label-pos, gap: title-gap)
  }

  ml-node(
    id,
    title:         title,
    subtitle:      subtitle,
    label:         label,
    kind:          "dataset",
    role:          "data",
    pos:           pos,
    after:         after,
    offset:        offset,
    fill:          none,
    stroke:        none,
    shape:         shapes.rect,
    corner-radius: 0pt,
    inset:         0pt,
    unit:          unit,
    ..options.named(),
  )
}

// ─── batch ────────────────────────────────────────────────────────────────────
// dataset with a "batch" badge and a deeper stack by default.
#let batch(id, title: auto, subtitle: none, stack: 4, ..options) = dataset(
  id,
  title:   if title == auto { id } else { title },
  subtitle: subtitle,
  samples: [batch],
  stack:   stack,
  ..options.named(),
)

// ─── tensor ───────────────────────────────────────────────────────────────────
// A tensor node; dims can be shown as subtitle (e.g. dims: [B × T × D]).
#let tensor(
  id,
  title:    auto,
  subtitle: none,
  dims:     none,
  size:     (1.65, 1.25),
  fill:     palette.tensor,
  stack:    5,
  ..options,
) = dataset(
  id,
  title:    if title == auto { id } else { title },
  subtitle: if dims != none { dims } else { subtitle },
  samples:  none,
  size:     size,
  fill:     fill,
  stack:    stack,
  ..options.named(),
)


// ─── vector ───────────────────────────────────────────────────────────────────
// A pill-shaped vector node.
//
// Parameters
// ──────────
//   dir        "h" (horizontal, default) | "v" (vertical)
//   size       Override the default pill dimensions.
//   stack      Number of stacked copies (default 1 = single pill).
//   stack-dx / stack-dy  Offset per layer.
//   label-pos  "inside" | "above" | "below"
//   title-gap  Spacing between label and shape when label-pos is above/below.
#let vector(
  id,
  title:         auto,
  subtitle:      none,
  dir:           "h",
  size:          auto,
  stack:         1,
  stack-dx:      2pt,
  stack-dy:      2pt,
  label-pos:     "inside",
  title-size:    0.92em,
  subtitle-size: 0.72em,
  title-gap:     4pt,
  fill:          palette.tensor,
  stroke:        rgb("#3f5f46"),
  unit:          default-unit,
  ..options,
) = {
  let title      = if title == auto { id } else { title }
  let base-size  = if dir == "v" { (0.85, 2.2) } else { (2.2, 0.85) }
  let (w, h)     = to-size(if size == auto { base-size } else { size }, unit: unit)
  let radius     = calc.min(w, h) / 2
  let text-lbl   = _text-block(title, subtitle: subtitle,
                                title-size: title-size, subtitle-size: subtitle-size)

  let label = if label-pos == "inside" {
    _draw-stack(stack, stack-dx, stack-dy, w, h, fill, stroke, radius, label: text-lbl)
  } else {
    let shape = _draw-stack(stack, stack-dx, stack-dy, w, h, fill, stroke, radius)
    _compose(shape, text-lbl, label-pos, gap: title-gap)
  }

  ml-node(
    id,
    title:         title,
    subtitle:      subtitle,
    label:         label,
    kind:          "vector",
    role:          "data",
    fill:          none,
    stroke:        none,
    shape:         shapes.rect,
    corner-radius: 0pt,
    inset:         0pt,
    unit:          unit,
    ..options.named(),
  )
}

// ─── embedding ────────────────────────────────────────────────────────────────
#let embedding(id, title: auto, subtitle: none, ..options) = vector(
  id,
  title:    if title == auto { id } else { title },
  subtitle: subtitle,
  fill:     rgb("#f0e6ff"),
  ..options.named(),
)


// ═══════════════════════════════════════════════════════════════════════════════
// IMAGE NODES
// ═══════════════════════════════════════════════════════════════════════════════

// ─── image-node ───────────────────────────────────────────────────────────────
// Parameters
// ──────────
//   cover       When true the image fills the node; border is hidden.
//   caption-pos "bottom" | "top" — caption placement when cover is true.
//   title-gap   Spacing between image and caption text.
#let image-node(
  id,
  title:        auto,
  subtitle:     none,
  src:          none,
  img:          none,
  image-size:   (2.2, 1.65),
  image-width:  auto,
  image-height: auto,
  image-fit:    "cover",
  cover:        false,
  caption-pos:  "bottom",
  title-size:   0.78em,
  subtitle-size: 0.64em,
  title-gap:    auto,
  unit:         default-unit,
  fill:         palette.image,
  stroke:       rgb("#5b5130"),
  ..options,
) = {
  let title  = if title == auto { id } else { title }
  let (iw, ih) = to-size(image-size, width: image-width, height: image-height, unit: unit)
  let resolved-title-gap = if title-gap == auto {
    if cover { 2pt } else { 3pt }
  } else {
    title-gap
  }

  if cover {
    let img-box = _image-box(src: src, img: img, width: iw, height: ih, fit: image-fit)
    let caption = if title != none or subtitle != none {
      let pad-side = if caption-pos == "top" {
        (bottom: resolved-title-gap)
      } else {
        (top: resolved-title-gap)
      }
      pad(..pad-side)[
        #_text-block(title, subtitle: subtitle, title-size: title-size, subtitle-size: subtitle-size)
      ]
    }
    let lbl = if caption == none       { img-box }
              else if caption-pos == "top" { stack(dir: ttb, spacing: 0pt, caption, img-box) }
              else                     { stack(dir: ttb, spacing: 0pt, img-box, caption) }

    ml-node(id, title: title, subtitle: subtitle, label: lbl,
            kind: "image", role: "data",
            fill: none, stroke: none, shape: shapes.rect,
            corner-radius: 0pt, inset: 0pt, ..options.named())
  } else {
    ml-node(id, title: title, subtitle: subtitle,
            label: _image-label(title, subtitle: subtitle, src: src, img: img,
                                 image-width: iw, image-height: ih, image-fit: image-fit,
                                 title-size: title-size, subtitle-size: subtitle-size,
                                 gap: resolved-title-gap),
            kind: "image", role: "data",
            fill: fill, stroke: stroke, shape: shapes.rect,
            corner-radius: 2pt, inset: 4pt, ..options.named())
  }
}

// ─── image-dataset ────────────────────────────────────────────────────────────
// A stacked-image node: `stack` image copies rendered with (dx, dy) offsets,
// each layer being a full-cover image (no border).  An optional caption is
// placed above or below the whole stack via `caption-pos`.
//
// Parameters
// ──────────
//   src / img        Image source path or pre-built Typst image element.
//   image-size       (w, h) of each image card in the stack.
//   image-width /
//   image-height     Override individual card dimensions (auto = from image-size).
//   image-fit        Fit mode passed to image() — "cover" by default.
//   stack            Number of stacked copies (default 3; 1 = single card).
//   stack-dx         Horizontal offset per layer (default 3pt).
//   stack-dy         Vertical offset per layer   (default 3pt).
//   caption-pos      "bottom" (default) | "top"
//   title-size /
//   subtitle-size    Font sizes for the caption text.
//   title-gap         Spacing between caption and image stack.
#let image-dataset(
  id,
  title:         auto,
  subtitle:      none,
  src:           none,
  img:           none,
  image-size:    (2.2, 1.65),
  image-width:   auto,
  image-height:  auto,
  image-fit:     "cover",
  caption-pos:   "bottom",
  stack:         3,
  stack-dx:      3pt,
  stack-dy:      3pt,
  title-size:    0.78em,
  subtitle-size: 0.64em,
  title-gap:     2pt,
  unit:          default-unit,
  ..options,
) = {
  let title    = if title == auto { id } else { title }
  let (iw, ih) = to-size(image-size, width: image-width, height: image-height, unit: unit)

  let img-stack = _draw-image-stack(stack, stack-dx, stack-dy, iw, ih, src, img, image-fit)

  let caption = if title != none or subtitle != none {
    pad(
      top:    if caption-pos == "bottom" { title-gap } else { 0pt },
      bottom: if caption-pos == "top"    { title-gap } else { 0pt },
    )[
      #_text-block(title, subtitle: subtitle,
                   title-size: title-size, subtitle-size: subtitle-size)
    ]
  }

  // Compose caption + stack without calling the built-in stack() function
  // (which is shadowed by the `stack` parameter in this scope).
  let lbl = if caption == none {
    img-stack
  } else {
    let first  = if caption-pos == "top"    { caption }   else { img-stack }
    let second = if caption-pos == "bottom" { caption }   else { img-stack }
    grid(rows: (auto, auto), gutter: 0pt, first, second)
  }

  ml-node(id, title: title, subtitle: subtitle, label: lbl,
          kind: "image-dataset", role: "data",
          fill: none, stroke: none, shape: shapes.rect,
          corner-radius: 0pt, inset: 0pt, unit: unit,
          ..options.named())
}


// ═══════════════════════════════════════════════════════════════════════════════
// UTILITY NODES
// ═══════════════════════════════════════════════════════════════════════════════

// ─── text-node ────────────────────────────────────────────────────────────────
// A borderless, background-free node for inline text or math formulas.
#let text-node(
  id,
  body,
  size:      1em,
  color:     black,
  node-size: auto,
  title-gap: 2pt,
  unit:      default-unit,
  ..options,
) = {
  let resolved-size = if node-size == auto { auto } else { to-size(node-size, unit: unit) }
  ml-node(id,
          label: align(center, text(size: size, fill: color)[#body]),
          kind: "text", role: "annotation",
        fill: none, stroke: none, inset: title-gap, corner-radius: 0pt,
          size: resolved-size, ..options.named())
}


// ═══════════════════════════════════════════════════════════════════════════════
// MODULE NODES  (module · layer · encoder · decoder · attention · …)
// ═══════════════════════════════════════════════════════════════════════════════

// ─── module ───────────────────────────────────────────────────────────────────
// Base for all "box-type" nodes.  Specific nodes (layer, encoder …) call this
// with appropriate shape / shape-kind / fill presets.
//
// Parameters
// ──────────
//   badge        Small text above the title.  none = no badge (default).
//   label-pos    "inside" (default) | "above" | "below"
//                  "inside"  → title rendered inside the Fletcher shape (standard)
//                  "above"   → shape drawn as Typst element, title sits above it
//                  "below"   → same, title sits below
//   shape-kind   Shape name used when label-pos ≠ "inside":
//                  "rect" | "pill" | "circle" | "diamond" |
//                  "trapezium-r" | "trapezium-l" | "hexagon"
//   title-size / subtitle-size  Font sizes passed to _text-block.
//   title-gap   Spacing between label and shape when label-pos is above/below.
//   size         Node dimensions as (w, h) in `unit`.
//                When label-pos ≠ "inside" and size is auto, defaults to (2.6, 1.4).
#let module(
  id,
  title:         auto,
  subtitle:      none,
  badge:         none,
  kind:          "module",
  role:          "module",
  fill:          palette.module,
  stroke:        rgb("#48415f"),
  shape:         shapes.rect,
  shape-kind:    "rect",
  size:          auto,
  label-pos:     "inside",
  title-size:    0.92em,
  subtitle-size: 0.72em,
  title-gap:     4pt,
  unit:          default-unit,
  ..options,
) = {
  let title    = if title == auto { id } else { title }
  let text-lbl = _text-block(title, subtitle: subtitle, badge: badge,
                              title-size: title-size, subtitle-size: subtitle-size)

  if label-pos == "inside" {
    // Standard mode: Fletcher renders the shape; label lives inside it.
    ml-node(id, title: title, subtitle: subtitle, label: text-lbl,
            kind: kind, role: role, fill: fill, stroke: stroke,
            shape: shape, size: size, corner-radius: 3pt, unit: unit,
            ..options.named())

  } else {
    // Drawn mode: we paint the shape ourselves so that text can float outside.
    let (w, h) = to-size(if size == auto { (2.6, 1.4) } else { size }, unit: unit)
    let shape-box = _draw-shape(w, h, fill, stroke, shape-kind)
    let lbl = _compose(shape-box, text-lbl, label-pos, gap: title-gap)
    ml-node(id, title: title, subtitle: subtitle, label: lbl,
            kind: kind, role: role,
            fill: none, stroke: none, shape: shapes.rect,
            corner-radius: 0pt, inset: 0pt, unit: unit,
            ..options.named())
  }
}

// ─── Specific module presets ──────────────────────────────────────────────────
// All badges default to `none`.  Set badge: [layer] (or whichever) to display.

#let layer(id, title: auto, subtitle: none, ..options) = module(
  id,
  title:      if title == auto { id } else { title },
  subtitle:   subtitle,
  fill:       rgb("#edf0ff"),
  shape-kind: "rect",
  ..options.named(),
)

#let encoder(id, title: auto, subtitle: none, ..options) = module(
  id,
  title:      if title == auto { id } else { title },
  subtitle:   subtitle,
  fill:       palette.encoder,
  shape:      shapes.trapezium.with(dir: right, angle: 18deg),
  shape-kind: "trapezium-r",
  ..options.named(),
)

#let decoder(id, title: auto, subtitle: none, ..options) = module(
  id,
  title:      if title == auto { id } else { title },
  subtitle:   subtitle,
  fill:       palette.decoder,
  shape:      shapes.trapezium.with(dir: left, angle: 18deg),
  shape-kind: "trapezium-l",
  ..options.named(),
)

#let attention(id, title: auto, subtitle: none, ..options) = module(
  id,
  title:      if title == auto { id } else { title },
  subtitle:   subtitle,
  fill:       palette.attention,
  shape:      shapes.diamond.with(fit: 0.45),
  shape-kind: "diamond",
  ..options.named(),
)

#let transformer(id, title: auto, subtitle: none, ..options) = module(
  id,
  title:      if title == auto { id } else { title },
  subtitle:   if subtitle == none { [self-attention + MLP] } else { subtitle },
  fill:       rgb("#ece7ff"),
  size:       (2.8, 1.6),
  shape-kind: "rect",
  ..options.named(),
)

#let io-node(id, title: auto, subtitle: none, ..options) = module(
  id,
  title:      if title == auto { id } else { title },
  subtitle:   subtitle,
  fill:       palette.output,
  shape:      shapes.pill,
  shape-kind: "pill",
  ..options.named(),
)

#let decision(id, title: auto, subtitle: none, ..options) = module(
  id,
  title:      if title == auto { id } else { title },
  subtitle:   subtitle,
  fill:       rgb("#fff1c7"),
  shape:      shapes.diamond,
  shape-kind: "diamond",
  ..options.named(),
)

#let operation(id, title: auto, subtitle: none, ..options) = module(
  id,
  title:      if title == auto { id } else { title },
  subtitle:   subtitle,
  kind:       "operation",
  role:       "operation",
  fill:       palette.operation,
  shape:      shapes.hexagon,
  shape-kind: "hexagon",
  ..options.named(),
)


// ─── gate-node ────────────────────────────────────────────────────────────────
// Renders a logic / math gate symbol with NO surrounding shape.
// The symbol is displayed as-is; an optional title floats above or below.
//
// Parameters
// ──────────
//   symbol       The operation to display. Built-in shorthands:
//                  "xor"  →  ⊕   (default)
//                  "mul"  →  ×
//                  "add"  →  +
//                  "and"  →  ∧
//                  "or"   →  ∨
//                Any other string or Typst content is rendered directly.
//   title        Optional descriptive label.
//   label-pos    "below" (default) | "above"
//   symbol-size  Font size of the gate symbol  (default 1.8em).
//   title-size   Font size of the optional title (default 0.78em).
//   gap          Spacing between symbol and title (default 2pt).
//   title-gap    Override spacing between symbol and title.
#let gate-node(
  id,
  symbol:      "xor",
  title:       none,
  label-pos:   "below",
  symbol-size: 1.8em,
  title-size:  0.78em,
  gap:         2pt,
  title-gap:   auto,
  dy:          3pt,   // shift symbol up (negative) or down (positive) to visually center it within the bbox
  unit:        default-unit,
  ..options,
) = {
  let sym-char = if symbol == "xor" { $plus.o$ }
                 else if symbol == "mul" { $times$ }
                 else if symbol == "add" { $+$ }
                 else if symbol == "and" { $and$ }
                 else if symbol == "or"  { $or$ }
                 else { [#symbol] }

  let sym-box = align(center + horizon)[#text(size: symbol-size)[#sym-char]]

  let text-lbl = if title != none {
    align(center)[#text(size: title-size, weight: "semibold")[#title]]
  } else { none }
  let resolved-gap = if title-gap == auto { gap } else { title-gap }

  // Asymmetrically pad the symbol box to visually center it within the node bbox, since some symbols (e.g. "xor") can appear optically higher or lower than geometric center.
  let top-pad    = if dy < 0pt { -dy } else { 0pt }
  let bottom-pad = if dy > 0pt {  dy } else { 0pt }

  let core = pad(top: top-pad, bottom: bottom-pad, sym-box)

  let lbl = if text-lbl == none {
    core
  } else if label-pos == "above" {
    stack(dir: ttb, spacing: resolved-gap, text-lbl, core)
  } else {
    stack(dir: ttb, spacing: resolved-gap, core, text-lbl)
  }

  ml-node(id, label: lbl,
          kind: "gate", role: "operation",
          fill: none, stroke: none,
          shape: shapes.rect,
          corner-radius: 0pt, inset: 0pt, unit: unit,
          ..options.named())
}


// ═══════════════════════════════════════════════════════════════════════════════
// ARROW NODE
// ═══════════════════════════════════════════════════════════════════════════════

// ─── arrow-node ───────────────────────────────────────────────────────────────
// A directional arrow node (unchanged from original).
//
// Parameters
// ──────────
//   dir        right | left | top | bottom
//   shape      "arrow" (default) | "chevron" | "triangle"
//   label-pos  "below" (default) | "above" | "inside"
//   size       (w, h) in `unit`.
//   title-gap  Spacing between label and arrow when label-pos is above/below.
#let arrow-node(
  id,
  title:     auto,
  subtitle:  none,
  dir:       right,
  shape:     "arrow",
  label-pos: "below",
  size:      (2.6, 1.1),
  title-gap: auto,
  title-size: auto,
  subtitle-size: auto,
  fill:      palette.operation,
  stroke:    rgb("#7a5030"),
  unit:      default-unit,
  ..options,
) = {
  let title  = if title == auto { id } else { title }
  let (w, h) = to-size(size, unit: unit)
  let sk     = (paint: stroke, thickness: 0.6pt, join: "miter")
  let resolved-title-gap = if title-gap == auto {
    if label-pos == "inside" { 0pt } else { 4pt }
  } else {
    title-gap
  }
  let resolved-title-size = if title-size == auto {
    if label-pos == "inside" { 0.92em } else { 0.78em }
  } else {
    title-size
  }
  let resolved-subtitle-size = if subtitle-size == auto {
    if label-pos == "inside" { 0.72em } else { 0.64em }
  } else {
    subtitle-size
  }

  let _pts(dir, kind) = {
    if kind == "triangle" {
      if      dir == right  { ((0pt, 0pt), (w, h / 2), (0pt, h)) }
      else if dir == left   { ((w, 0pt), (0pt, h / 2), (w, h)) }
      else if dir == bottom { ((0pt, 0pt), (w, 0pt), (w / 2, h)) }
      else                  { ((0pt, h), (w, h), (w / 2, 0pt)) }

    } else if kind == "chevron" {
      let t = 0.35
      if      dir == right  {
        ((0pt, 0pt), (w*(1-t), 0pt), (w, h/2), (w*(1-t), h), (0pt, h), (w*t, h/2))
      } else if dir == left {
        ((w, 0pt), (w*t, 0pt), (0pt, h/2), (w*t, h), (w, h), (w*(1-t), h/2))
      } else if dir == bottom {
        ((0pt, 0pt), (w, 0pt), (w, h*(1-t)), (w/2, h), (0pt, h*(1-t)))
      } else {
        ((0pt, h), (w, h), (w, h*t), (w/2, 0pt), (0pt, h*t))
      }

    } else {
      // "arrow" – classic 7-point notched arrow
      if      dir == right  {
        let ny = h * 0.22; let tx = w * 0.60
        ((0pt, ny), (tx, ny), (tx, 0pt), (w, h/2), (tx, h), (tx, h - ny), (0pt, h - ny))
      } else if dir == left {
        let ny = h * 0.22; let tx = w * 0.40
        ((w, ny), (tx, ny), (tx, 0pt), (0pt, h/2), (tx, h), (tx, h - ny), (w, h - ny))
      } else if dir == bottom {
        let nx = w * 0.22; let ty = h * 0.60
        ((nx, 0pt), (w-nx, 0pt), (w-nx, ty), (w, ty), (w/2, h), (0pt, ty), (nx, ty))
      } else {
        let nx = w * 0.22; let ty = h * 0.40
        ((nx, h), (w-nx, h), (w-nx, ty), (w, ty), (w/2, 0pt), (0pt, ty), (nx, ty))
      }
    }
  }

  if label-pos == "inside" {
    let node-shape = if type(shape) == str { shapes.chevron.with(dir: dir) } else { shape }
    ml-node(id, title: title, subtitle: subtitle,
            label: _text-block(title, subtitle: subtitle,
                                title-size: resolved-title-size,
                                subtitle-size: resolved-subtitle-size),
            kind: "arrow", role: "operation",
            fill: fill, stroke: stroke, shape: node-shape,
            size: size, unit: unit, corner-radius: 2pt,
            ..options.named())
  } else {
    let kind = if type(shape) == str { shape } else { "arrow" }
    let arrow-box = box(width: w, height: h)[
      #polygon(fill: fill, stroke: sk, .._pts(dir, kind))
    ]
    let caption = pad(top: 1pt, bottom: 1pt)[
      #_text-block(title, subtitle: subtitle,
                   title-size: resolved-title-size,
                   subtitle-size: resolved-subtitle-size)
    ]
    let lbl = if label-pos == "above" {
      stack(dir: ttb, spacing: resolved-title-gap, caption, arrow-box)
    } else {
      stack(dir: ttb, spacing: resolved-title-gap, arrow-box, caption)
    }
    ml-node(id, title: title, subtitle: subtitle, label: lbl,
            kind: "arrow", role: "operation",
            fill: none, stroke: none, shape: shapes.rect,
            corner-radius: 0pt, inset: 0pt, unit: unit,
            ..options.named())
  }
}

// ─── compare-node ─────────────────────────────────────────────────────────────
// A right-pointing isosceles triangle ("play button" style).
// Vertices: (0, 0) → (w, h/2) → (0, h)
//
// Parameters
// ──────────
//   title / subtitle / badge   Text displayed according to label-pos.
//   size       (w, h) of the triangle.  Keep w ≈ h for a balanced shape.
//   fill       Fill colour.
//   stroke     Outline colour.
//   label-pos  "inside" (default) | "above" | "below" | "right" | "left"
//                "inside" → text centred in the left portion of the triangle
//                           (around the centroid: x = w/3, y = h/2)
//                "right"  → text to the right of the tip  (most readable)
//                "above" / "below" / "left"  → same behaviour as other nodes
//   title-size / subtitle-size   Font sizes.
//   title-gap  Spacing between label and triangle when label-pos is outside.
#let compare-node(
  id,
  title:         auto,
  subtitle:      none,
  badge:         none,
  size:          (1.8, 1.8),
  fill:          palette.operation,
  stroke:        rgb("#7a5030"),
  label-pos:     "inside",
  title-gap:     auto,
  title-size:    0.82em,
  subtitle-size: 0.72em,
  unit:          default-unit,
  ..options,
) = {
  let title  = if title == auto { id } else { title }
  let (w, h) = to-size(size, unit: unit)
  let sk     = (paint: stroke, thickness: 0.7pt, join: "miter")
  let resolved-title-gap = if title-gap == auto {
    if label-pos == "right" or label-pos == "left" { 6pt } else { 4pt }
  } else {
    title-gap
  }

  let text-lbl = _text-block(title, subtitle: subtitle, badge: badge,
                              title-size: title-size, subtitle-size: subtitle-size)

  // ── Triangle drawing ──────────────────────────────────────────────────────
  // Centroid sits at (w/3, h/2).  Text is centred inside a box covering
  // the usable interior area (the leftmost 62 % of the triangle).
  let tri-box(inner: none) = box(width: w, height: h)[
    #polygon(fill: fill, stroke: sk,
             (0pt, 0pt), (w, h / 2), (0pt, h))
    #if inner != none {
      place(left + top)[
        #box(width: w * 0.62, height: h)[
          #align(center + horizon)[#inner]
        ]
      ]
    }
  ]

  // ── Label + triangle composition ──────────────────────────────────────────
  let lbl = if label-pos == "inside" {
    tri-box(inner: text-lbl)

  } else if label-pos == "above" {
    stack(dir: ttb, spacing: resolved-title-gap, align(center)[#text-lbl], tri-box())

  } else if label-pos == "below" {
    stack(dir: ttb, spacing: resolved-title-gap, tri-box(), align(center)[#text-lbl])

  } else if label-pos == "right" {
    // Text to the right of the tip — most natural for this shape
    stack(dir: ltr, spacing: resolved-title-gap, tri-box(), align(left + horizon)[#text-lbl])

  } else if label-pos == "left" {
    stack(dir: ltr, spacing: resolved-title-gap, align(right + horizon)[#text-lbl], tri-box())

  } else {
    tri-box(inner: text-lbl)
  }

  ml-node(id, title: title, subtitle: subtitle, label: lbl,
          kind: "compare", role: "operation",
          fill: none, stroke: none, shape: shapes.rect,
          corner-radius: 0pt, inset: 0pt, unit: unit,
          ..options.named())
}


// ═══════════════════════════════════════════════════════════════════════════════
// GROUP
// ═══════════════════════════════════════════════════════════════════════════════

#let group(
  id,
  children,
  title:    auto,
  subtitle: none,
  title-size: 0.92em,
  subtitle-size: 0.72em,
  title-gap: 8pt,
  fill:     palette.group,
  stroke:   rgb("#77808a"),
  outset:   10pt,
  ..options,
) = {
  let title = if title == auto { id } else { title }
  ml-node(id,
          title: title, subtitle: subtitle,
          label: _text-block(title, subtitle: subtitle,
                              title-size: title-size,
                              subtitle-size: subtitle-size),
          kind: "group", role: "group",
          enclose: ensure-array(children).map(node-ref),
          fill: fill,
          stroke: (paint: stroke, dash: "dashed"),
          inset: title-gap, outset: outset,
          layer: -1, snap: false,
          ..options.named())
}
