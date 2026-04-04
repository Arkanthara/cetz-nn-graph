#import "../lib.typ": *

#graph-canvas({
  let ds = make-dataset("Image\nDataset", pos: (1.0, 0.0))
  let enc = make-trapezoid("Feature\nEncoder", subtitle: "Conv stack", after: ds, gap: 1.2)
  let head = make-box("Head", subtitle: "Prediction", after: enc, gap: 1.2)

  draw-node(ds)
  draw-node(enc)
  draw-node(head)

  let arrows = (
    make-arrow(ds, enc, from-outer: true, label: [input]),
    make-arrow(enc, head, label: [features]),
  )
  draw-arrows(arrows)
})
