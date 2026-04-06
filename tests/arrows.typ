#import "@preview/cetz:0.4.2": draw
#import "../lib.typ": *
#import "./_helpers.typ": showcase, join_lines

= Arrow routing

#showcase(
  "make-arrow and draw-arrow",
  join_lines((
    "#graph-canvas({",
    "  let left = make-box(\"Left\", pos: (1.5, 0.8))",
    "  let right = make-box(\"Right\", pos: (8.0, 0.8))",
    "  let down = make-box(\"Down\", pos: (8.0, -2.2))",
    "  let stack = make-dataset(\"Stack\", images: 4, pos: (1.5, -2.2))",
    "",
    "  draw-node(left)",
    "  draw-node(right)",
    "  draw-node(down)",
    "  draw-node(stack)",
    "",
    "  let a = make-arrow(",
    "    left,",
    "    right,",
    "    out-side: \"right\",",
    "    in-side: \"left\",",
    "    auto-spacing: true,",
    "    spacing: 0.6,",
    "    mode: \"hvh\",",
    "    mode-shift: (2, 1.4),",
    "    label: [main],",
    "    label-side: \"below\",",
    "    label-gap: 0.35,",
    "    label-dx: 0.15,",
    "    label-dy: -0.05,",
    "  )",
    "  let b = make-arrow(",
    "    stack,",
    "    down,",
    "    out-side: \"top\",",
    "    in-side: \"bottom\",",
    "    from-outer: true,",
    "    from-outer-value: 0.4,",
    "    to-outer: true,",
    "    to-outer-value: 0.3,",
    "    auto-spacing: false,",
    "    mode: \"hv\",",
    "    mode-shifts: (1.2, 0.8),",
    "    label: [stack],",
    "  )",
    "  let c = make-arrow(",
    "    down,",
    "    right,",
    "    out-side: \"right\",",
    "    in-side: \"bottom\",",
    "    mode: \"vh\",",
    "    label: [return],",
    "  )",
    "",
    "  draw-arrow(a)",
    "  draw-arrow(b)",
    "  draw-arrow(c)",
    "})",
  )),
  {
    graph-canvas({
      let left = make-box("Left", pos: (1.5, 0.8))
      let right = make-box("Right", pos: (8.0, 0.8))
      let down = make-box("Down", pos: (8.0, -2.2))
      let stack = make-dataset("Stack", images: 4, pos: (1.5, -2.2))

      draw-node(left)
      draw-node(right)
      draw-node(down)
      draw-node(stack)

      let a = make-arrow(
        left,
        right,
        out-side: "right",
        in-side: "left",
        auto-spacing: true,
        spacing: 0.6,
        mode: "hvh",
        mode-shift: (2, 1.4),
        label: [main],
        label-side: "below",
        label-gap: 0.35,
        label-dx: 0.15,
        label-dy: -0.05,
      )
      let b = make-arrow(
        stack,
        down,
        out-side: "top",
        in-side: "bottom",
        from-outer: true,
        from-outer-value: 0.4,
        to-outer: true,
        to-outer-value: 0.3,
        auto-spacing: false,
        mode: "hv",
        mode-shifts: (1.2, 0.8),
        label: [stack],
      )
      let c = make-arrow(
        down,
        right,
        out-side: "right",
        in-side: "bottom",
        mode: "vh",
        label: [return],
      )

      draw-arrow(a)
      draw-arrow(b)
      draw-arrow(c)
    })
  }
)

#showcase(
  "edge-label",
  join_lines((
    "#graph-canvas({",
    "  draw.line((1, 0), (6, 0), mark: (end: \">\"), stroke: (paint: black, thickness: 0.75pt))",
    "  edge-label((1, 0), (6, 0), [input], side: \"above\", gap: 0.30, dx: 0.2, dy: 0.0, size: 0.5em)",
    "})",
  )),
  {
    graph-canvas({
      draw.line((1, 0), (6, 0), mark: (end: ">"), stroke: (paint: black, thickness: 0.75pt))
      edge-label((1, 0), (6, 0), [input], side: "above", gap: 0.30, dx: 0.2, dy: 0.0, size: 0.5em)
    })
  }
)

#showcase(
  "draw-arrows side distribution",
  join_lines((
    "#graph-canvas({",
    "  let up = make-box(\"Up\", pos: (1.5, 1.4))",
    "  let down = make-box(\"Down\", pos: (1.5, -1.4))",
    "  let target = make-dataset(\"Embed\", images: 2, image-size: (1.3, 1.6), pos: (7.0, 0.0))",
    "",
    "  draw-node(up)",
    "  draw-node(down)",
    "  draw-node(target)",
    "",
    "  let a = make-arrow(up, target, out-side: \"right\", in-side: \"left\", label: [a])",
    "  let b = make-arrow(down, target, out-side: \"right\", in-side: \"left\", label: [b])",
    "  draw-arrows((a, b))",
    "})",
  )),
  {
    graph-canvas({
      let up = make-box("Up", pos: (1.5, 1.4))
      let down = make-box("Down", pos: (1.5, -1.4))
      let target = make-dataset("Embed", images: 2, image-size: (1.3, 1.6), pos: (7.0, 0.0))

      draw-node(up)
      draw-node(down)
      draw-node(target)

      let a = make-arrow(up, target, out-side: "right", in-side: "left", label: [a])
      let b = make-arrow(down, target, out-side: "right", in-side: "left", label: [b])
      draw-arrows((a, b))
    })
  }
)

#showcase(
  "draw-arrows side distribution (4 arrows)",
  join_lines((
    "#graph-canvas({",
    "  let n1 = make-box(\"N1\", pos: (1.2, 2.1))",
    "  let n2 = make-box(\"N2\", pos: (1.2, 0.7))",
    "  let n3 = make-box(\"N3\", pos: (1.2, -0.7))",
    "  let n4 = make-box(\"N4\", pos: (1.2, -2.1))",
    "  let target = make-dataset(\"Embed\", images: 2, image-size: (1.3, 1.8), pos: (7.0, 0.0))",
    "",
    "  draw-node(n1)",
    "  draw-node(n2)",
    "  draw-node(n3)",
    "  draw-node(n4)",
    "  draw-node(target)",
    "",
    "  let arrows = (",
    "    make-arrow(n1, target, out-side: \"right\", in-side: \"left\", label: [1]),",
    "    make-arrow(n2, target, out-side: \"right\", in-side: \"left\", label: [2]),",
    "    make-arrow(n3, target, out-side: \"right\", in-side: \"left\", label: [3]),",
    "    make-arrow(n4, target, out-side: \"right\", in-side: \"left\", label: [4]),",
    "  )",
    "  draw-arrows(arrows)",
    "})",
  )),
  {
    graph-canvas({
      let n1 = make-box("N1", pos: (1.2, 2.1))
      let n2 = make-box("N2", pos: (1.2, 0.7))
      let n3 = make-box("N3", pos: (1.2, -0.7))
      let n4 = make-box("N4", pos: (1.2, -2.1))
      let target = make-dataset("Embed", images: 2, image-size: (1.3, 1.8), pos: (7.0, 0.0))

      draw-node(n1)
      draw-node(n2)
      draw-node(n3)
      draw-node(n4)
      draw-node(target)

      let arrows = (
        make-arrow(n1, target, out-side: "right", in-side: "left", label: [1]),
        make-arrow(n2, target, out-side: "right", in-side: "left", label: [2]),
        make-arrow(n3, target, out-side: "right", in-side: "left", label: [3]),
        make-arrow(n4, target, out-side: "right", in-side: "left", label: [4]),
      )
      draw-arrows(arrows)
    })
  }
)

#showcase(
  "draw-arrows mixed in/out side distribution",
  join_lines((
    "#graph-canvas({",
    "  let source = make-box(\"Source\", pos: (1.5, 1.4))",
    "  let sink = make-box(\"Sink\", pos: (1.5, -1.4))",
    "  let compare = make-box(\"Compare\", pos: (7.0, 0.0))",
    "",
    "  draw-node(source)",
    "  draw-node(sink)",
    "  draw-node(compare)",
    "",
    "  let arrows = (",
    "    make-arrow(source, compare, out-side: \"right\", in-side: \"left\", label: [in]),",
    "    make-arrow(compare, sink, out-side: \"left\", in-side: \"right\", label: [out]),",
    "  )",
    "  draw-arrows(arrows)",
    "})",
  )),
  {
    graph-canvas({
      let source = make-box("Source", pos: (1.5, 1.4))
      let sink = make-box("Sink", pos: (1.5, -1.4))
      let compare = make-box("Compare", pos: (7.0, 0.0))

      draw-node(source)
      draw-node(sink)
      draw-node(compare)

      let arrows = (
        make-arrow(source, compare, out-side: "right", in-side: "left", label: [in]),
        make-arrow(compare, sink, out-side: "left", in-side: "right", label: [out]),
      )
      draw-arrows(arrows)
    })
  }
)

#showcase(
  "draw-arrows explicit endpoint order",
  join_lines((
    "#graph-canvas({",
    "  let top = make-box(\"Top\", pos: (1.6, 1.4))",
    "  let bottom = make-box(\"Bottom\", pos: (1.6, -1.4))",
    "  let target = make-box(\"Target\", pos: (7.0, 0.0))",
    "",
    "  draw-nodes((top, bottom, target))",
    "",
    "  let arrows = (",
    "    make-arrow(top, target, in-side: \"left\", order: 2, label: [second]),",
    "    make-arrow(bottom, target, in-side: \"left\", order: 1, label: [first]),",
    "  )",
    "  draw-arrows(arrows)",
    "})",
  )),
  {
    graph-canvas({
      let top = make-box("Top", pos: (1.6, 1.4))
      let bottom = make-box("Bottom", pos: (1.6, -1.4))
      let target = make-box("Target", pos: (7.0, 0.0))

      draw-nodes((top, bottom, target))

      let arrows = (
        make-arrow(top, target, in-side: "left", order: 2, label: [second]),
        make-arrow(bottom, target, in-side: "left", order: 1, label: [first]),
      )
      draw-arrows(arrows)
    })
  }
)

#showcase(
  "draw-arrows same order uses code order",
  join_lines((
    "#graph-canvas({",
    "  let a = make-box(\"A\", pos: (1.5, 1.4))",
    "  let b = make-box(\"B\", pos: (1.5, -1.4))",
    "  let target = make-box(\"Target\", pos: (7.0, 0.0))",
    "",
    "  draw-nodes((a, b, target))",
    "",
    "  let arrows = (",
    "    make-arrow(a, target, in-side: \"left\", order: 1, label: [first in code]),",
    "    make-arrow(b, target, in-side: \"left\", order: 1, label: [second in code]),",
    "  )",
    "  draw-arrows(arrows)",
    "})",
  )),
  {
    graph-canvas({
      let a = make-box("A", pos: (1.5, 1.4))
      let b = make-box("B", pos: (1.5, -1.4))
      let target = make-box("Target", pos: (7.0, 0.0))

      draw-nodes((a, b, target))

      let arrows = (
        make-arrow(a, target, in-side: "left", order: 1, label: [first in code]),
        make-arrow(b, target, in-side: "left", order: 1, label: [second in code]),
      )
      draw-arrows(arrows)
    })
  }
)

#showcase(
  "draw-arrows with auto-distribute false",
  join_lines((
    "#graph-canvas({",
    "  let up = make-box(\"Up\", pos: (1.6, 1.2))",
    "  let down = make-box(\"Down\", pos: (1.6, -1.2))",
    "  let target = make-dataset(\"Embed\", images: 2, image-size: (1.3, 1.6), pos: (7.0, 0.0))",
    "",
    "  draw-node(up)",
    "  draw-node(down)",
    "  draw-node(target)",
    "",
    "  let arrows = (",
    "    make-arrow(up, target, out-side: \"right\", in-side: \"left\", label: [a]),",
    "    make-arrow(down, target, out-side: \"right\", in-side: \"left\", label: [b]),",
    "  )",
    "  draw-arrows(arrows, auto-distribute: false)",
    "})",
  )),
  {
    graph-canvas({
      let up = make-box("Up", pos: (1.6, 1.2))
      let down = make-box("Down", pos: (1.6, -1.2))
      let target = make-dataset("Embed", images: 2, image-size: (1.3, 1.6), pos: (7.0, 0.0))

      draw-node(up)
      draw-node(down)
      draw-node(target)

      let arrows = (
        make-arrow(up, target, out-side: "right", in-side: "left", label: [a]),
        make-arrow(down, target, out-side: "right", in-side: "left", label: [b]),
      )
      draw-arrows(arrows, auto-distribute: false)
    })
  }
)
