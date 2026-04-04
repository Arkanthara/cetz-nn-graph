#import "../lib.typ": *

#graph-canvas({
  let img = make-image-node(
    "Single\nImage",
    src: "/assets/test.jpg",
    image-width: 2.1,
    image-height: 2.1,
    image-pad: 0.08,
    unit: 0.72cm,
    pos: (1.0, 0.0),
    title-position: "below",
  )
  let ds = make-image-dataset(
    "Image\nDataset",
    src: "/assets/test.jpg",
    images: 4,
    image-width: 1.5,
    image-height: 2.0,
    image-spacing: 0.16,
    unit: 0.72cm,
    title-position: "below",
    after: img,
    gap: 1.4,
  )
  let latent = make-latent-space(
    "Latent\nSpace",
    height: 3.0,
    after: ds,
    gap: 1.4,
  )

  draw-node(img)
  draw-node(ds)
  draw-node(latent)

  let arrows = (
    make-arrow(img, ds, label: [samples]),
    make-arrow(ds, latent, label: [encode]),
  )
  draw-arrows(arrows)
})
