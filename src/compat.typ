#import "core/utils.typ": as-node-id, default-unit
#import "core/spec.typ": ml-edge
#import "core/position.typ": right-of, node-ref
#import "fletcher.typ": shapes
#import "ml/nodes.typ": dataset, image-node, image-dataset, module, encoder, decoder, tensor, io-node

#let _legacy-id(title, id: auto, fallback: "node") = {
  if id != auto and id != none { as-node-id(id, fallback: fallback) }
  else { as-node-id(title, fallback: fallback) }
}

#let _legacy-pos(pos, after, y) = {
  if pos != none and pos != auto {
    pos
  } else if after != none and after != auto {
    right-of(after)
  } else if y != none {
    (0, y)
  } else {
    auto
  }
}

#let make-dataset(
  title,
  id: auto,
  subtitle: none,
  legend: none,
  legend-position: "below",
  images: 3,
  image-size: (1.9, 2.3),
  image-spacing: 0.22,
  title-position: "inside",
  pos: none,
  after: none,
  gap: 1.0,
  y: none,
  color: rgb("#a8c8e8"),
  ..options,
) = dataset(
  _legacy-id(title, id: id, fallback: "dataset"),
  title: title,
  subtitle: subtitle,
  samples: if legend == none { [dataset] } else { legend },
  stack: images,
  size: image-size,
  fill: color,
  pos: _legacy-pos(pos, after, y),
  ..options.named(),
)

#let make-image-node(
  title,
  id: auto,
  subtitle: none,
  legend: none,
  legend-position: "below",
  src: none,
  img: none,
  image-size: none,
  image-width: none,
  image-height: none,
  image-fit: "cover",
  unit: default-unit,
  title-position: "below",
  pos: none,
  after: none,
  gap: 1.0,
  y: none,
  color: rgb("#ffffff"),
  border: true,
  ..options,
) = image-node(
  _legacy-id(title, id: id, fallback: "image"),
  title: title,
  subtitle: subtitle,
  src: src,
  img: img,
  image-size: if image-size == none { (2.2, 2.2) } else { image-size },
  image-width: if image-width == none { auto } else { image-width },
  image-height: if image-height == none { auto } else { image-height },
  image-fit: image-fit,
  unit: unit,
  fill: color,
  stroke: if border { rgb("#222222") } else { none },
  pos: _legacy-pos(pos, after, y),
  ..options.named(),
)

#let make-image-dataset(
  title,
  id: auto,
  subtitle: none,
  legend: none,
  src: none,
  img: none,
  images: 3,
  image-size: none,
  image-width: none,
  image-height: none,
  image-spacing: 0.22,
  image-fit: "cover",
  unit: default-unit,
  title-position: "below",
  pos: none,
  after: none,
  gap: 1.0,
  y: none,
  color: rgb("#a8c8e8"),
  border: true,
  ..options,
) = image-dataset(
  _legacy-id(title, id: id, fallback: "image-dataset"),
  title: title,
  subtitle: subtitle,
  src: src,
  img: img,
  stack: images,
  image-size: if image-size == none { (1.9, 2.3) } else { image-size },
  image-width: if image-width == none { auto } else { image-width },
  image-height: if image-height == none { auto } else { image-height },
  image-fit: image-fit,
  unit: unit,
  fill: color,
  stroke: if border { rgb("#222222") } else { none },
  pos: _legacy-pos(pos, after, y),
  ..options.named(),
)

#let make-box(
  title,
  id: auto,
  subtitle: none,
  legend: none,
  legend-position: "below",
  size: auto,
  pos: none,
  after: none,
  gap: 1.0,
  y: none,
  color: rgb("#a0b8f5"),
  ..options,
) = module(
  _legacy-id(title, id: id, fallback: "box"),
  title: title,
  subtitle: subtitle,
  fill: color,
  size: size,
  pos: _legacy-pos(pos, after, y),
  ..options.named(),
)

#let make-square(title, size: 2.2, ..options) = make-box(title, size: (size, size), ..options.named())

#let make-circle(
  title,
  id: auto,
  subtitle: none,
  radius: 1.1,
  pos: none,
  after: none,
  gap: 1.0,
  y: none,
  color: rgb("#f0c2a0"),
  ..options,
) = module(
  _legacy-id(title, id: id, fallback: "circle"),
  title: title,
  subtitle: subtitle,
  fill: color,
  shape: shapes.circle,
  size: (radius * 2, radius * 2),
  pos: _legacy-pos(pos, after, y),
  ..options.named(),
)

#let make-trapezoid(
  title,
  id: auto,
  subtitle: none,
  mode: "encoder",
  width: 2.8,
  big-half: 1.65,
  small-half: 0.80,
  pos: none,
  after: none,
  gap: 1.0,
  y: none,
  color: rgb("#b0dba0"),
  ..options,
) = {
  let ctor = if mode == "decoder" { decoder } else { encoder }
  ctor(
    _legacy-id(title, id: id, fallback: mode),
    title: title,
    subtitle: subtitle,
    fill: color,
    size: (width, calc.max(big-half, small-half) * 2),
    pos: _legacy-pos(pos, after, y),
    ..options.named(),
  )
}

#let make-rectangle(
  title,
  id: auto,
  subtitle: none,
  width: 0.7,
  height: 3.2,
  pos: none,
  after: none,
  gap: 1.0,
  y: none,
  color: rgb("#fcd97a"),
  ..options,
) = tensor(
  _legacy-id(title, id: id, fallback: "latent"),
  title: title,
  subtitle: subtitle,
  size: (width, height),
  stack: 1,
  fill: color,
  pos: _legacy-pos(pos, after, y),
  ..options.named(),
)

#let make-latent-space = make-rectangle

#let make-text(
  title,
  id: auto,
  subtitle: none,
  pos: none,
  after: none,
  gap: 1.0,
  y: none,
  ..options,
) = io-node(
  _legacy-id(title, id: id, fallback: "text"),
  title: title,
  subtitle: subtitle,
  pos: _legacy-pos(pos, after, y),
  ..options.named(),
)

#let make-arrow(
  from,
  to,
  out-side: none,
  in-side: none,
  label: none,
  mode: auto,
  corner-radius: auto,
  radius: auto,
  bend: 0deg,
  order: none,
  from-outer: false,
  to-outer: false,
  ..options,
) = ml-edge(
  from,
  to,
  from-side: out-side,
  to-side: in-side,
  label: label,
  corner-radius: if corner-radius != auto { corner-radius } else { radius },
  bend: bend,
  ..options.named(),
)

#let set-arrow-defaults(options: (:)) = make-arrow.with(..options)
#let set-dataset-defaults(options: (:)) = make-dataset.with(..options)
#let set-image-node-defaults(options: (:)) = make-image-node.with(..options)
#let set-image-dataset-defaults(options: (:)) = make-image-dataset.with(..options)
#let set-latent-space-defaults(options: (:)) = make-latent-space.with(..options)
#let set-rectangle-defaults(options: (:)) = make-rectangle.with(..options)
#let set-trapezoid-defaults(options: (:)) = make-trapezoid.with(..options)
#let set-box-defaults(options: (:)) = make-box.with(..options)
#let set-square-defaults(options: (:)) = make-square.with(..options)
#let set-circle-defaults(options: (:)) = make-circle.with(..options)
#let set-text-defaults(options: (:)) = make-text.with(..options)

#let chars-cap(width, min: 8, scale: 4.2) = calc.max(min, calc.floor(width * scale))
#let node-size(node, outer: false) = node.size
#let node-edge(node, side: "right", outer: false, outer-value: none) = none
#let node-anchor(node, side: "right", outer: false, outer-value: none) = node-ref(node)
#let auto-pos-right(after, width, gap: 1.0, y: none, outer-after: true) = right-of(after)
#let side-dir(side) = if side == "left" { (-1, 0) } else if side == "right" { (1, 0) } else if side == "top" { (0, -1) } else { (0, 1) }
#let edge-label(a, b, txt, ..options) = txt
#let draw-node-emoji(node, emoji, ..options) = emoji
