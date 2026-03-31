#import "../lib.typ": *

#graph-canvas({
  let ds = make-dataset("Training\nImages", pos: (1.0, 0.0))
  let enc = make-trapezoid("Feature\nEncoder", subtitle: "Conv stack", after: ds, gap: 1.2)
  let feat = make-dataset(
    "Feature\nTensor",
    images: 5,
    image-size: (1.1, 1.5),
    image-spacing: 0.1,
    title-position: "below",
    after: enc,
    gap: 1.2,
  )
  let cls = make-box("Classifier", subtitle: "MLP", after: feat, gap: 1.2)
  let out = make-box("Class\nScores", after: cls, gap: 1.0)

  draw-node(ds)
  draw-node(enc)
  draw-node(feat)
  draw-node(cls)
  draw-node(out)

  let arrows = (
    make-arrow(ds, enc, from-outer: true, label: [input]),
    make-arrow(enc, feat, label: [features]),
    make-arrow(feat, cls, from-outer: true, label: [flatten]),
    make-arrow(cls, out, label: [logits]),
  )
  draw-arrows(arrows)
})
