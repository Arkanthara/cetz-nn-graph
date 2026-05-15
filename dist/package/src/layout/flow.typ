#import "../core/position.typ": is-auto-pos
#import "../core/spec.typ": with-pos

#let _edge-id(ref) = {
  if type(ref) == dictionary and "id" in ref {
    ref.id
  } else if type(ref) == str {
    ref
  } else if type(ref) == label {
    str(ref)
  } else {
    repr(ref)
  }
}

#let _direction-step(direction, step, lane-gap) = {
  if direction == "down" {
    ((0, step), (lane-gap, 0))
  } else if direction == "left" {
    ((-step, 0), (0, lane-gap))
  } else if direction == "up" {
    ((0, -step), (lane-gap, 0))
  } else {
    ((step, 0), (0, lane-gap))
  }
}

#let _add(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
#let _mul(a, k) = (a.at(0) * k, a.at(1) * k)

#let _should-place(node, overwrite) = overwrite or is-auto-pos(node.pos)

#let layout-pipeline(nodes, start: (0, 0), step: 1, direction: "right", overwrite: false) = {
  let (main, lane) = _direction-step(direction, step, 1)
  let out = ()
  let i = 0
  for node in nodes {
    if _should-place(node, overwrite) {
      out.push(with-pos(node, _add(start, _mul(main, i))))
    } else {
      out.push(node)
    }
    i += 1
  }
  out
}

#let layout-grid(nodes, columns: 3, start: (0, 0), col-gap: 1, row-gap: 1, overwrite: false) = {
  let out = ()
  for (i, node) in nodes.enumerate() {
    if _should-place(node, overwrite) {
      let x = i - calc.floor(i / columns) * columns
      let y = calc.floor(i / columns)
      out.push(with-pos(node, (start.at(0) + x * col-gap, start.at(1) + y * row-gap)))
    } else {
      out.push(node)
    }
  }
  out
}

#let layout-dag(
  nodes,
  edges: (),
  start: (0, 0),
  rank-gap: 1,
  lane-gap: 1,
  direction: "right",
  overwrite: false,
) = {
  let ranks = (:)
  for node in nodes {
    ranks.insert(node.id, 0)
  }

  for _ in range(calc.max(1, nodes.len())) {
    for edge in edges {
      let from = _edge-id(edge.from)
      let to = _edge-id(edge.to)
      if from in ranks and to in ranks {
        ranks.insert(to, calc.max(ranks.at(to), ranks.at(from) + 1))
      }
    }
  }

  let rank-counts = (:)
  for node in nodes {
    let rank = ranks.at(node.id, default: 0)
    let key = str(rank)
    rank-counts.insert(key, rank-counts.at(key, default: 0) + 1)
  }

  let seen = (:)
  let (main, lane) = _direction-step(direction, rank-gap, lane-gap)
  let out = ()
  for node in nodes {
    if _should-place(node, overwrite) {
      let rank = ranks.at(node.id, default: 0)
      let key = str(rank)
      let idx = seen.at(key, default: 0)
      let count = rank-counts.at(key, default: 1)
      seen.insert(key, idx + 1)
      let centered = idx - (count - 1) / 2
      let pos = _add(start, _add(_mul(main, rank), _mul(lane, centered)))
      out.push(with-pos(node, pos))
    } else {
      out.push(node)
    }
  }
  out
}

#let apply-layout(nodes, edges: (), layout: "dag") = {
  if layout == none or layout == false {
    nodes
  } else if type(layout) == function {
    layout(nodes, edges: edges)
  } else if type(layout) == dictionary {
    let kind = layout.at("kind", default: "dag")
    let options = layout
    options.remove("kind")
    if kind == "pipeline" {
      layout-pipeline(nodes, ..options)
    } else if kind == "grid" {
      layout-grid(nodes, ..options)
    } else {
      layout-dag(nodes, edges: edges, ..options)
    }
  } else if layout == "pipeline" or layout == "flow" {
    layout-pipeline(nodes)
  } else if layout == "grid" {
    layout-grid(nodes)
  } else {
    layout-dag(nodes, edges: edges)
  }
}
