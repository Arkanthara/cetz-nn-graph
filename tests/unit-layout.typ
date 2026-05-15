#import "../lib.typ": *
#import "./_helpers.typ": showcase, join_lines

= Unit: layout

#let a = module("a", title: [A])
#let b = module("b", title: [B])
#let c = module("c", title: [C])
#let fixed = module("fixed", title: [Manual], pos: (9, 9))

#let pipe = layout-pipeline((a, b, c), start: (1, 2), step: 2)
#assert.eq(pipe.at(0).pos, (1, 2))
#assert.eq(pipe.at(1).pos, (3, 2))
#assert.eq(pipe.at(2).pos, (5, 2))

#let preserved = layout-pipeline((a, fixed), start: (0, 0))
#assert.eq(preserved.at(1).pos, (9, 9))

#let edges = (
  ml-edge("a", "b"),
  ml-edge("a", "c"),
)
#let dag = layout-dag((a, b, c), edges: edges)
#assert.eq(dag.at(0).pos, (0, 0))
#assert.eq(dag.at(1).pos, (1, -0.5))
#assert.eq(dag.at(2).pos, (1, 0.5))

#let grid = layout-grid((a, b, c), columns: 2, col-gap: 2, row-gap: 3)
#assert.eq(grid.at(0).pos, (0, 0))
#assert.eq(grid.at(1).pos, (2, 0))
#assert.eq(grid.at(2).pos, (0, 3))

#showcase(
  "DAG layout result",
  join_lines((
    "#layout-dag((a, b, c), edges: edges)",
  )),
  text(dag.map(n => n.id + ": " + repr(n.pos)).join("\n")),
)
