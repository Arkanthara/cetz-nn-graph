#import "utils.typ": as-node-id, merge, to-size, default-unit
#import "position.typ": is-auto-pos, right-of, offset-pos

#let node-id(node) = node.id
#let node-pos(node) = node.pos

#let _resolve-pos(pos, after, offset) = {
  let base = if not is-auto-pos(pos) {
    pos
  } else if after != none and after != auto {
    right-of(after)
  } else {
    auto
  }

  if offset == none or offset == auto or offset == (0, 0) {
    base
  } else {
    offset-pos(base, by: offset)
  }
}

#let ml-node(
  id,
  title: auto,
  subtitle: none,
  label: auto,
  kind: "module",
  role: none,
  pos: auto,
  after: none,
  offset: (0, 0),
  size: auto,
  width: auto,
  height: auto,
  unit: default-unit,
  shape: auto,
  fill: auto,
  stroke: auto,
  corner-radius: auto,
  inset: auto,
  outset: auto,
  extrude: (0,),
  enclose: (),
  layer: auto,
  snap: 0,
  meta: (:),
  ..extra,
) = {
  let id = as-node-id(id)
  let title = if title == auto { id } else { title }
  let label = if label == auto { title } else { label }
  let (width, height) = to-size(size, width: width, height: height, unit: unit)

  (
    class: "neural-node",
    id: id,
    title: title,
    subtitle: subtitle,
    label: label,
    kind: kind,
    role: role,
    pos: _resolve-pos(pos, after, offset),
    size: (width, height),
    shape: shape,
    fill: fill,
    stroke: stroke,
    corner-radius: corner-radius,
    inset: inset,
    outset: outset,
    extrude: extrude,
    enclose: enclose,
    layer: layer,
    snap: snap,
    meta: meta,
  )
}

#let ml-edge(
  from,
  to,
  label: none,
  kind: "flow",
  mark: "-|>",
  from-side: none,
  to-side: none,
  via: (),
  bend: 0deg,
  corner: none,
  corner-radius: auto,
  label-pos: 50%,
  label-side: auto,
  label-sep: auto,
  stroke: auto,
  dash: none,
  decorations: none,
  crossing: false,
  layer: 0,
  floating: false,
  name: none,
  meta: (:),
  ..extra,
) = (
  class: "neural-edge",
  from: from,
  to: to,
  label: label,
  kind: kind,
  mark: mark,
  from-side: from-side,
  to-side: to-side,
  via: via,
  bend: bend,
  corner: corner,
  corner-radius: corner-radius,
  label-pos: label-pos,
  label-side: label-side,
  label-sep: label-sep,
  stroke: stroke,
  dash: dash,
  decorations: decorations,
  crossing: crossing,
  layer: layer,
  floating: floating,
  name: name,
  meta: meta,
)

#let with-pos(node, pos) = {
  let out = node
  out.pos = pos
  out
}

#let with-meta(node, meta) = {
  let out = node
  out.meta = merge(out.meta, meta)
  out
}
