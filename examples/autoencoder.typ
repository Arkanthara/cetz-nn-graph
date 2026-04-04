#import "../lib.typ": *

#graph-canvas({
  let input = make-image-dataset(
    "Input\nImages",
    src: "/assets/test.jpg",
    images: 3,
    image-width: 1.9,
    image-height: 2.3,
    image-spacing: 0.22,
    unit: 0.72cm,
    title-position: "below",
    pos: (1.0, 0.0),
  )
  let enc = make-trapezoid("Encoder", subtitle: "Downsample", after: input, gap: 1.2)
  let latent = make-latent-space(
    "Latent\nSpace",
    height: 3.0,
    after: enc,
    gap: 1.2,
  )
  let dec = make-trapezoid("Decoder", subtitle: "Upsample", mode: "decoder", after: latent, gap: 1.2)
  let output = make-image-dataset(
    "Reconstruction",
    src: "/assets/test.jpg",
    images: 3,
    image-width: 1.9,
    image-height: 2.3,
    image-spacing: 0.22,
    unit: 0.72cm,
    title-position: "below",
    after: dec,
    gap: 1.2,
  )

  draw-node(input)
  draw-node(enc)
  draw-node(latent)
  draw-node(dec)
  draw-node(output)

  let arrows = (
    make-arrow(input, enc, from-outer: true, label: [input]),
    make-arrow(enc, latent, label: [encode]),
    make-arrow(latent, dec, label: [decode]),
    make-arrow(dec, output, from-outer: true, label: [output]),
  )
  draw-arrows(arrows)
})
