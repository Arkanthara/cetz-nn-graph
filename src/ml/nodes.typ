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
  unit: default-unit,
  fill: palette.image,
  stroke: rgb("#5b5130"),
  ..options,
) = {
  let title = if title == auto { id } else { title }
  let (iw, ih) = to-size(image-size, width: image-width, height: image-height, unit: unit)
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
