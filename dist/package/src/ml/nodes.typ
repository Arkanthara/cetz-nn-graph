#import "../fletcher.typ": shapes
#import "../core/spec.typ": ml-node
#import "../core/utils.typ": default-unit, to-length, to-size, ensure-array, as-node-id
#import "../core/position.typ": node-ref

#let palette = (
  data: rgb("#d7ecff"),
  image: rgb("#fff7d6"),
  tensor: rgb("#e5f4df"),
  module: rgb("#e8e4ff"),
  operation: rgb("#f5e6d8"),
  encoder: rgb("#dff2e1"),
  decoder: rgb("#fde6d7"),
  attention: rgb("#f3def1"),
  output: rgb("#e7ecef"),
  group: rgb("#f7f7f7"),
)

#let _text-block(title, subtitle: none, badge: none, title-size: 0.92em, subtitle-size: 0.72em) = align(center)[
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

#let _image-label(title, subtitle: none, src: none, img: none, image-width: 24mm, image-height: 18mm, image-fit: "cover") = stack(
  dir: ttb,
  spacing: 3pt,
  align(center)[#_image-box(src: src, img: img, width: image-width, height: image-height, fit: image-fit)],
  _text-block(title, subtitle: subtitle, title-size: 0.78em, subtitle-size: 0.64em),
)

#let dataset(
  id,
  title: auto,
  subtitle: none,
  samples: none,
  pos: auto,
  after: none,
  offset: (0, 0),
  size: (2.1, 1.45),
  unit: default-unit,
  fill: palette.data,
  stroke: rgb("#384655"),
  stack: 3,
  shape: auto,
  ..options,
) = {
  let title = if title == auto { id } else { title }
  let badge = if samples == none { [dataset] } else { [#samples] }
  ml-node(
    id,
    title: title,
    subtitle: subtitle,
    label: _text-block(title, subtitle: subtitle, badge: badge),
    kind: "dataset",
    role: "data",
    pos: pos,
    after: after,
    offset: offset,
    size: size,
    unit: unit,
    fill: fill,
    stroke: stroke,
    shape: shape,
    corner-radius: 3pt,
    extrude: if stack <= 1 { (0,) } else { range(stack).map(i => i * 2) },
    ..options.named(),
  )
}

#let batch(id, title: auto, subtitle: none, stack: 4, ..options) = dataset(
  id,
  title: if title == auto { id } else { title },
  subtitle: subtitle,
  samples: [batch],
  stack: stack,
  ..options.named(),
)

#let tensor(
  id,
  title: auto,
  subtitle: none,
  dims: none,
  size: (1.65, 1.25),
  fill: palette.tensor,
  stack: 5,
  ..options,
) = dataset(
  id,
  title: if title == auto { id } else { title },
  subtitle: if dims == none { subtitle } else { dims },
  samples: [tensor],
  size: size,
  fill: fill,
  stack: stack,
  ..options.named(),
)

#let vector(id, title: auto, subtitle: none, ..options) = ml-node(
  id,
  title: if title == auto { id } else { title },
  subtitle: subtitle,
  label: _text-block(if title == auto { id } else { title }, subtitle: subtitle, badge: [vector]),
  kind: "vector",
  role: "data",
  shape: shapes.pill,
  fill: palette.tensor,
  stroke: rgb("#3f5f46"),
  size: (2.2, 0.85),
  ..options.named(),
)

#let embedding(id, title: auto, subtitle: none, ..options) = vector(
  id,
  title: if title == auto { id } else { title },
  subtitle: if subtitle == none { [embedding] } else { subtitle },
  fill: rgb("#f0e6ff"),
  ..options.named(),
)

// ─── image-node ────────────────────────────────────────────────────────────────
//
// New parameters:
//   cover       (bool, default false)
//     When true, the image fills the entire node area.  The node border and
//     background are hidden (stroke: none, fill: none, inset: 0pt) so the raw
//     image is the only visual element of the node itself.
//
//   caption-pos (string, default "bottom")
//     Where to render the title/subtitle relative to the image when cover is
//     true.  Accepted values: "bottom" | "top".
//     Has no effect when cover is false.
//
// ───────────────────────────────────────────────────────────────────────────────
#let image-node(
  id,
  title: auto,
  subtitle: none,
  src: none,
  img: none,
  image-size: (2.2, 1.65),
  image-width: auto,
  image-height: auto,
  image-fit: "cover",
  cover: false,
  caption-pos: "bottom",
  unit: default-unit,
  fill: palette.image,
  stroke: rgb("#5b5130"),
  ..options,
) = {
  let title = if title == auto { id } else { title }
  let (iw, ih) = to-size(image-size, width: image-width, height: image-height, unit: unit)

  if cover {
    // Build image and optional caption as separate stack items so that the
    // caption sits visually outside the image boundary.
    let img-box = _image-box(src: src, img: img, width: iw, height: ih, fit: image-fit)

    let caption = if title != none or subtitle != none {
      // Pad on the side that faces the image so the gap is always between
      // the caption text and the image, regardless of caption position.
      let caption-pad = if caption-pos == "top" { (bottom: 2pt) } else { (top: 2pt) }
      pad(..caption-pad)[
        #_text-block(title, subtitle: subtitle, title-size: 0.78em, subtitle-size: 0.64em)
      ]
    }

    let lbl = if caption == none {
      img-box
    } else if caption-pos == "top" {
      stack(dir: ttb, spacing: 0pt, caption, img-box)
    } else {
      stack(dir: ttb, spacing: 0pt, img-box, caption)
    }

    ml-node(
      id,
      title: title,
      subtitle: subtitle,
      label: lbl,
      kind: "image",
      role: "data",
      // No fill and no stroke: the image box itself is the only visual.
      fill: none,
      stroke: none,
      shape: shapes.rect,
      corner-radius: 0pt,
      inset: 0pt,
      ..options.named(),
    )
  } else {
    ml-node(
      id,
      title: title,
      subtitle: subtitle,
      label: _image-label(title, subtitle: subtitle, src: src, img: img, image-width: iw, image-height: ih, image-fit: image-fit),
      kind: "image",
      role: "data",
      fill: fill,
      stroke: stroke,
      shape: shapes.rect,
      corner-radius: 2pt,
      inset: 4pt,
      ..options.named(),
    )
  }
}

#let image-dataset(id, title: auto, subtitle: none, stack: 3, ..options) = {
  let n = image-node(
    id,
    title: if title == auto { id } else { title },
    subtitle: subtitle,
    ..options.named(),
  )
  n.kind = "image-dataset"
  n.extrude = if stack <= 1 { (0,) } else { range(stack).map(i => i * 2) }
  n
}

// ─── text-node ─────────────────────────────────────────────────────────────────
// A borderless, background-free node for inline text or mathematical formulas.
//
// Usage:
//   #text-node("t1", $bold(z) = f(bold(x))$)
//   #text-node("t2", [… or any Typst content …])
//
// Parameters:
//   body        – any Typst content (text, math, markup)
//   size        – font size of the body (default 1em)
//   color       – text/math color (default black)
// ───────────────────────────────────────────────────────────────────────────────
#let text-node(
  id,
  body,
  size: 1em,
  color: black,
  node-size: auto,
  unit: default-unit,
  ..options,
) = {
  let resolved-size = if node-size == auto { auto } else { to-size(node-size, unit: unit) }
  ml-node(
    id,
    label: align(center, text(size: size, fill: color)[#body]),
    kind: "text",
    role: "annotation",
    fill: none,
    stroke: none,
    inset: 2pt,
    corner-radius: 0pt,
    size: resolved-size,
    ..options.named(),
  )
}

#let module(
  id,
  title: auto,
  subtitle: none,
  badge: none,
  kind: "module",
  role: "module",
  fill: palette.module,
  stroke: rgb("#48415f"),
  shape: shapes.rect,
  size: auto,
  ..options,
) = {
  let title = if title == auto { id } else { title }
  ml-node(
    id,
    title: title,
    subtitle: subtitle,
    label: _text-block(title, subtitle: subtitle, badge: badge),
    kind: kind,
    role: role,
    fill: fill,
    stroke: stroke,
    shape: shape,
    size: size,
    corner-radius: 3pt,
    ..options.named(),
  )
}

#let operation(id, title: auto, subtitle: none, ..options) = module(
  id,
  title: if title == auto { id } else { title },
  subtitle: subtitle,
  badge: [op],
  kind: "operation",
  role: "operation",
  fill: palette.operation,
  shape: shapes.hexagon,
  ..options.named(),
)

#let layer(id, title: auto, subtitle: none, ..options) = module(
  id,
  title: if title == auto { id } else { title },
  subtitle: subtitle,
  badge: [layer],
  fill: rgb("#edf0ff"),
  ..options.named(),
)

#let encoder(id, title: auto, subtitle: none, ..options) = module(
  id,
  title: if title == auto { id } else { title },
  subtitle: subtitle,
  badge: [encoder],
  fill: palette.encoder,
  shape: shapes.trapezium.with(dir: right, angle: 18deg),
  ..options.named(),
)

#let decoder(id, title: auto, subtitle: none, ..options) = module(
  id,
  title: if title == auto { id } else { title },
  subtitle: subtitle,
  badge: [decoder],
  fill: palette.decoder,
  shape: shapes.trapezium.with(dir: left, angle: 18deg),
  ..options.named(),
)

#let attention(id, title: auto, subtitle: none, ..options) = module(
  id,
  title: if title == auto { id } else { title },
  subtitle: subtitle,
  badge: [attention],
  fill: palette.attention,
  shape: shapes.diamond.with(fit: 0.45),
  ..options.named(),
)

#let transformer(id, title: auto, subtitle: none, ..options) = module(
  id,
  title: if title == auto { id } else { title },
  subtitle: if subtitle == none { [self-attention + MLP] } else { subtitle },
  badge: [transformer],
  fill: rgb("#ece7ff"),
  size: (2.8, 1.6),
  ..options.named(),
)

#let io-node(id, title: auto, subtitle: none, ..options) = module(
  id,
  title: if title == auto { id } else { title },
  subtitle: subtitle,
  badge: [io],
  fill: palette.output,
  shape: shapes.pill,
  ..options.named(),
)

#let decision(id, title: auto, subtitle: none, ..options) = module(
  id,
  title: if title == auto { id } else { title },
  subtitle: subtitle,
  fill: rgb("#fff1c7"),
  shape: shapes.diamond,
  ..options.named(),
)

// ─── arrow-node ─────────────────────────────────────────────────────────────
//
// A node displayed as a directional arrow, with a label that can sit inside
// the arrow or above/below it.
//
// Parameters
// ──────────
//   dir         Direction the arrow points.
//               Accepts Typst cardinal values: right, left, top, bottom.
//
//   shape       Arrow visual style:
//                 "arrow"    (default) — classic 7-point notched arrow with tail
//                 "chevron"  — 6-point pentagon arrow, no tail
//                 "triangle" — simple 3-point triangle
//               When label-pos is "inside", you may instead pass a Fletcher
//               shape function directly (e.g. shapes.chevron.with(dir: right)).
//
//   label-pos   Where to render the title relative to the arrow visual:
//                 "inside" — text rendered inside the Fletcher node shape
//                 "above"  — arrow drawn as a polygon; label floats above
//                 "below"  — arrow drawn as a polygon; label floats below
//               Default: "below"
//
//   size        (width, height) of the arrow visual expressed in `unit`.
//               Default: (2.6, 1.1)
//
//   fill        Fill colour of the arrow.
//   stroke      Border colour of the arrow.
//
// Examples
// ────────
//   #arrow-node("fwd",  dir: right,  shape: "arrow",   label-pos: "below")
//   #arrow-node("up",   dir: top,    shape: "chevron",  label-pos: "above")
//   #arrow-node("tri",  dir: bottom, shape: "triangle", label-pos: "inside")
//
// ─────────────────────────────────────────────────────────────────────────────
#let arrow-node(
  id,
  title:     auto,
  subtitle:  none,
  dir:       right,
  shape:     "arrow",
  label-pos: "below",
  size:      (2.6, 1.1),
  fill:      palette.operation,
  stroke:    rgb("#7a5030"),
  unit:      default-unit,
  ..options,
) = {
  let title  = if title == auto { id } else { title }
  let (w, h) = to-size(size, unit: unit)
  let sk     = (paint: stroke, thickness: 0.6pt, join: "miter")

  // ── polygon point-sets ─────────────────────────────────────────────────────
  // All coordinates are absolute lengths derived from (w, h).
  let _pts(dir, kind) = {
    if kind == "triangle" {
      if      dir == right  { ((0pt, 0pt),  (w,  h/2), (0pt, h  )) }
      else if dir == left   { ((w,   0pt),  (0pt, h/2), (w,  h  )) }
      else if dir == bottom { ((0pt, 0pt),  (w,  0pt), (w/2, h  )) }
      else                  { ((0pt, h  ),  (w,  h  ), (w/2, 0pt)) }  // top

    } else if kind == "chevron" {
      // 6-point arrow, no rectangular tail
      let t = 0.35
      if      dir == right  {
        ((0pt,    0pt),   (w*(1-t), 0pt),   (w,     h/2),
         (w*(1-t), h),   (0pt,      h),     (w*t,   h/2))
      } else if dir == left {
        ((w,      0pt),   (w*t,    0pt),    (0pt,   h/2),
         (w*t,    h),    (w,       h),      (w*(1-t), h/2))
      } else if dir == bottom {
        ((0pt,    0pt),   (w,      0pt),    (w,     h*(1-t)),
         (w/2,   h),     (0pt,    h*(1-t)))
      } else {                                                         // top
        ((0pt,   h),     (w,      h),      (w,     h*t),
         (w/2,  0pt),    (0pt,   h*t))
      }

    } else {
      // "arrow" – classic 7-point notched arrow with a rectangular tail
      if      dir == right  {
        let ny = h * 0.22; let tx = w * 0.60
        ((0pt, ny), (tx, ny), (tx, 0pt), (w, h/2), (tx, h), (tx, h - ny), (0pt, h - ny))
      } else if dir == left {
        let ny = h * 0.22; let tx = w * 0.40
        ((w, ny), (tx, ny), (tx, 0pt), (0pt, h/2), (tx, h), (tx, h - ny), (w, h - ny))
      } else if dir == bottom {
        let nx = w * 0.22; let ty = h * 0.60
        ((nx, 0pt), (w - nx, 0pt), (w - nx, ty), (w, ty), (w/2, h), (0pt, ty), (nx, ty))
      } else {                                                         // top
        let nx = w * 0.22; let ty = h * 0.40
        ((nx, h), (w - nx, h), (w - nx, ty), (w, ty), (w/2, 0pt), (0pt, ty), (nx, ty))
      }
    }
  }

  if label-pos == "inside" {
    // ── Fletcher node: text label rendered inside the arrow outline ──────────
    // If the caller provided a raw string shape name, map to the closest
    // Fletcher built-in (shapes.chevron honours the `dir` parameter and is
    // the best universal match). If the caller passed a Fletcher shape
    // function directly, use it as-is.
    let node-shape = if type(shape) == str {
      shapes.chevron.with(dir: dir)
    } else {
      shape
    }
    ml-node(
      id,
      title:         title,
      subtitle:      subtitle,
      label:         _text-block(title, subtitle: subtitle),
      kind:          "arrow",
      role:          "operation",
      fill:          fill,
      stroke:        stroke,
      shape:         node-shape,
      size:          size,
      unit:          unit,
      corner-radius: 2pt,
      ..options.named(),
    )

  } else {
    // ── Drawn-polygon mode: arrow visual + caption stacked ───────────────────
    // The ml-node acts as an invisible container (no fill, no stroke) so that
    // the hand-drawn polygon is the only visible element.
    let kind = if type(shape) == str { shape } else { "arrow" }
    let arrow-box = box(width: w, height: h)[
      #polygon(fill: fill, stroke: sk, .._pts(dir, kind))
    ]
    let caption = pad(top: 1pt, bottom: 1pt)[
      #_text-block(title, subtitle: subtitle, title-size: 0.78em, subtitle-size: 0.64em)
    ]
    let lbl = if label-pos == "above" {
      stack(dir: ttb, spacing: 4pt, caption, arrow-box)
    } else {
      stack(dir: ttb, spacing: 4pt, arrow-box, caption)
    }
    ml-node(
      id,
      title:         title,
      subtitle:      subtitle,
      label:         lbl,
      kind:          "arrow",
      role:          "operation",
      fill:          none,
      stroke:        none,
      shape:         shapes.rect,
      corner-radius: 0pt,
      inset:         0pt,
      unit:          unit,
      ..options.named(),
    )
  }
}

#let group(
  id,
  children,
  title: auto,
  subtitle: none,
  fill: palette.group,
  stroke: rgb("#77808a"),
  outset: 10pt,
  ..options,
) = {
  let title = if title == auto { id } else { title }
  ml-node(
    id,
    title: title,
    subtitle: subtitle,
    label: _text-block(title, subtitle: subtitle),
    kind: "group",
    role: "group",
    enclose: ensure-array(children).map(node-ref),
    fill: fill,
    stroke: (paint: stroke, dash: "dashed"),
    inset: 8pt,
    outset: outset,
    layer: -1,
    snap: false,
    ..options.named(),
  )
}
