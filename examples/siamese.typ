#import "../lib.typ": *

#graph-canvas({
  let a = make-dataset("Input A", pos: (1.0, 1.4))
  let b = make-dataset("Input B", pos: (1.0, -1.4))
  let enc-a = make-box("Shared\nEncoder", after: a, gap: 1.2)
  let enc-b = make-box("Shared\nEncoder", after: b, gap: 1.2)
  let emb = make-dataset(
    "Embedding",
    images: 2,
    image-size: (1.2, 1.5),
    title-position: "below",
    after: enc-a,
    gap: 1.6,
    y: 0.0,
  )
  let cmp = make-box("Distance", after: emb, gap: 1.2)

  draw-node(a)
  draw-node(b)
  draw-node(enc-a)
  draw-node(enc-b)
  draw-node(emb)
  draw-node(cmp)

  let arrows = (
    make-arrow(a, enc-a, from-outer: true, label: [input]),
    make-arrow(b, enc-b, from-outer: true, label: [input]),
    make-arrow(enc-a, emb, in-side: "left", label: [embed]),
    make-arrow(enc-b, emb, in-side: "left", label: [embed]),
    make-arrow(emb, cmp, from-outer: true, label: [compare]),
  )
  draw-arrows(arrows)
})
