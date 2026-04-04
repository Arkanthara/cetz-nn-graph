#import "../lib.typ": *
#import "./_helpers.typ": showcase, join_lines

= Geometry helpers

#showcase(
  "chars-cap",
  join_lines((
    "#chars-cap(2.0)",
    "#chars-cap(4.0, min: 10, scale: 5.0)",
  )),
  {
  text(repr(chars-cap(2.0)) + "\n" + repr(chars-cap(4.0, min: 10, scale: 5.0)))
})

#showcase(
  "node-size",
  join_lines((
    "#let ds = make-dataset(\"A\", images: 3, image-size: (1.9, 2.3), image-spacing: 0.22)",
    "#node-size(ds)",
    "#node-size(ds, outer: true)",
  )),
  {
  let ds = make-dataset("A", images: 3, image-size: (1.9, 2.3), image-spacing: 0.22)
  text(repr(node-size(ds)) + "\n" + repr(node-size(ds, outer: true)))
})

#showcase(
  "node-edge",
  join_lines((
    "#let ds = make-dataset(\"A\", images: 3, image-size: (1.9, 2.3), image-spacing: 0.22)",
    "#node-edge(ds, side: \"right\")",
    "#node-edge(ds, side: \"right\", outer: true)",
    "#node-edge(ds, side: \"right\", outer: true, outer-value: 0.8)",
  )),
  {
  let ds = make-dataset("A", images: 3, image-size: (1.9, 2.3), image-spacing: 0.22)
  text(
    repr(node-edge(ds, side: "right"))
      + "\n" + repr(node-edge(ds, side: "right", outer: true))
      + "\n" + repr(node-edge(ds, side: "right", outer: true, outer-value: 0.8))
  )
})

#showcase(
  "node-anchor",
  join_lines((
    "#let box = make-box(\"B\", size: (2.4, 1.8), pos: (5, 0))",
    "#node-anchor(box, side: \"left\")",
    "#node-anchor(box, side: \"top\")",
    "#node-anchor(box, side: \"right\", outer: true, outer-value: 0.5)",
  )),
  {
  let box = make-box("B", size: (2.4, 1.8), pos: (5, 0))
  text(
    repr(node-anchor(box, side: "left"))
      + "\n" + repr(node-anchor(box, side: "top"))
      + "\n" + repr(node-anchor(box, side: "right", outer: true, outer-value: 0.5))
  )
})

#showcase(
  "auto-pos-right",
  join_lines((
    "#let left = make-box(\"Left\", size: (2.2, 1.6), pos: (2, 0))",
    "#auto-pos-right(left, 3.0, gap: 1.25)",
    "#auto-pos-right(left, 3.0, gap: 1.25, y: -1.0, outer-after: false)",
  )),
  {
  let left = make-box("Left", size: (2.2, 1.6), pos: (2, 0))
  text(
    repr(auto-pos-right(left, 3.0, gap: 1.25))
      + "\n" + repr(auto-pos-right(left, 3.0, gap: 1.25, y: -1.0, outer-after: false))
  )
})

#showcase(
  "side-dir",
  join_lines((
    "#side-dir(\"left\")",
    "#side-dir(\"right\")",
    "#side-dir(\"top\")",
    "#side-dir(\"bottom\")",
  )),
  {
  text(
    repr(side-dir("left"))
      + "\n" + repr(side-dir("right"))
      + "\n" + repr(side-dir("top"))
      + "\n" + repr(side-dir("bottom"))
  )
})
