#import "../lib.typ": *

#graph-canvas({
  let input = make-dataset("Input\nImage", pos: (1.0, 0.0), images: 1, image-size: (1.7, 2.1))
  let enc = make-trapezoid("Encoder", subtitle: "Downsample", after: input, gap: 1.2)
  let ctx = make-box("Context", subtitle: "Global", after: enc, gap: 1.2)
  let dec = make-trapezoid("Decoder", subtitle: "Upsample", mode: "decoder", after: ctx, gap: 1.2)
  let mask = make-dataset("Segmentation\nMask", images: 1, image-size: (1.7, 2.1), after: dec, gap: 1.2)

  draw-node(input)
  draw-node(enc)
  draw-node(ctx)
  draw-node(dec)
  draw-node(mask)

  let arrows = (
    make-arrow(input, enc, from-outer: true, label: [input]),
    make-arrow(enc, ctx, label: [encode]),
    make-arrow(ctx, dec, label: [decode]),
    make-arrow(dec, mask, from-outer: true, label: [mask]),
  )
  draw-arrows(arrows)
})
