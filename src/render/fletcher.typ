#import "../fletcher.typ": diagram as f-diagram, node as f-node, edge as f-edge, shapes
#import "../core/position.typ": anchor-ref, node-ref
#import "../layout/flow.typ": apply-layout

#let _side(side) = {
  if side == "above" or side == "top" {
    left
  } else if side == "below" or side == "bottom" {
    right
  } else if side == "center" {
    center
  } else {
    side
  }
}

#let _render-node(n) = {
  f-node(
    n.pos,
    n.label,
    name: label(n.id),
    width: n.size.at(0),
    height: n.size.at(1),
    shape: n.shape,
    fill: n.fill,
    stroke: n.stroke,
    corner-radius: n.corner-radius,
    inset: n.inset,
    outset: n.outset,
    extrude: n.extrude,
    enclose: n.enclose,
    layer: n.layer,
    snap: n.snap,
  )
}

#let _render-edge(e) = {

  // Resolve start and end anchors (respects from-side / to-side).
  let from-anchor = anchor-ref(e.from, side: e.from-side)
  let to-anchor   = anchor-ref(e.to,   side: e.to-side)

  // ── Build the vertex list ─────────────────────────────────────────────────
  let vertices = if e.orthogonal != false {

    // Determine the Fletcher bend-notation to use for each segment:
    //   "-|"  horizontal-first (go right/left until aligned, then turn)
    //   "|-"  vertical-first   (go up/down    until aligned, then turn)
    let dir = if e.orthogonal == "v" { "|-" } else { "-|" }

    // Collect all required waypoints in order: source → via… → destination.
    // Via points are optional; omitting them yields a simple L-shaped path.
    let pts = (from-anchor,)
    if e.via != none { pts += e.via }
    pts.push(to-anchor)

    // For every consecutive pair (p1, p2), insert one orthogonal corner vertex.
    // Fletcher interprets (p1, "-|", p2) as:
    //   "travel horizontally from p1 to p2's column, then vertically to p2"
    // — producing a true right-angle bend without any manual grid hops.
    let verts = (pts.at(0),)
    for i in range(pts.len() - 1) {
      let p1 = pts.at(i)
      let p2 = pts.at(i + 1)
      verts.push((p1, dir, p2)) // synthetic 90° corner
      verts.push(p2)
    }
    verts

  } else {

    // Standard routing: chain anchors and raw via points as given.
    let verts = (from-anchor,)
    if e.via != none { verts += e.via }
    verts.push(to-anchor)
    verts

  }
  // ─────────────────────────────────────────────────────────────────────────

  f-edge(
    ..vertices,
    e.mark,
    label:         e.label,
    label-pos:     e.label-pos,
    label-side:    _side(e.label-side),
    label-sep:     e.label-sep,
    stroke:        e.stroke,
    dash:          e.dash,
    decorations:   e.decorations,
    bend:          e.bend,
    corner:        e.corner,
    corner-radius: e.corner-radius,
    crossing:      e.crossing,
    layer:         e.layer,
    floating:      e.floating,
    shift:         (e.from-shift, e.to-shift),
  )
}

#let ml-diagram(
  nodes,
  edges: (),
  layout: "dag",
  spacing: 2.8em,
  cell-size: 0pt,
  axes: (ltr, ttb),
  debug: false,
  node-stroke: none,
  node-fill: none,
  node-inset: 6pt,
  node-outset: 0pt,
  node-corner-radius: 3pt,
  edge-stroke: 0.052em,
  edge-corner-radius: 3pt,
  label-size: 0.82em,
  crossing-fill: white,
) = {
  let nodes = apply-layout(nodes, edges: edges, layout: layout)
  let objects = ()
  for n in nodes {
    objects.push(_render-node(n))
  }
  for e in edges {
    objects.push(_render-edge(e))
  }
  f-diagram(
    ..objects,
    spacing: spacing,
    cell-size: cell-size,
    axes: axes,
    debug: debug,
    node-stroke: node-stroke,
    node-fill: node-fill,
    node-inset: node-inset,
    node-outset: node-outset,
    node-corner-radius: node-corner-radius,
    edge-stroke: edge-stroke,
    edge-corner-radius: edge-corner-radius,
    label-size: label-size,
    crossing-fill: crossing-fill,
  )
}

#let draw-graph(nodes: (), arrows: (), edges: auto, layout: "dag", ..options) = {
  let edges = if edges == auto { arrows } else { edges }
  ml-diagram(nodes, edges: edges, layout: layout, ..options.named())
}

#let graph-canvas(body, length: auto, ..options) = {
  f-diagram(
    body,
    spacing: options.named().at("spacing", default: 2.8em),
    cell-size: options.named().at("cell-size", default: 0pt),
    axes: options.named().at("axes", default: (ltr, ttb)),
    debug: options.named().at("debug", default: false),
    node-stroke: options.named().at("node-stroke", default: none),
    edge-stroke: options.named().at("edge-stroke", default: 0.052em),
    node-corner-radius: options.named().at("node-corner-radius", default: 3pt),
    edge-corner-radius: options.named().at("edge-corner-radius", default: 3pt),
    label-size: options.named().at("label-size", default: 0.82em),
  )
}

#let draw-node(node) = _render-node(node)
#let draw-nodes(nodes) = {
  for node in nodes {
    _render-node(node)
  }
}
#let draw-arrow(edge) = _render-edge(edge)
#let draw-arrows(edges, auto-distribute: true) = {
  for edge in edges {
    _render-edge(edge)
  }
}
#let spread-arrows(edges, auto-distribute: true) = edges
