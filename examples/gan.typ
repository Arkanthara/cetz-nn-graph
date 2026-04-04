#import "../lib.typ": *

#graph-canvas({
  let real = make-dataset("Real\nImages", pos: (1.0, 1.6))
  let noise = make-box("Noise z", pos: (1.0, -1.6))
  let gen = make-box("Generator", after: noise, gap: 1.2)
  let fake = make-dataset("Fake\nImages", after: gen, gap: 1.2)
  let disc = make-box("Discriminator", after: fake, gap: 1.4, y: 0.0)
  let out = make-box("Score", after: disc, gap: 1.0)

  draw-node(real)
  draw-node(noise)
  draw-node(gen)
  draw-node(fake)
  draw-node(disc)
  draw-node(out)

  let arrows = (
    make-arrow(noise, gen, label: [noise]),
    make-arrow(gen, fake, from-outer: true, label: [fake]),
    make-arrow(fake, disc, from-outer: true, label: [fake]),
    make-arrow(real, disc, out-side: "right", in-side: "top", from-outer: true, mode: "hv", label: [real]),
    make-arrow(disc, out, label: [score]),
  )
  draw-arrows(arrows)
})
