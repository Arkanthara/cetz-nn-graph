#import "../lib.typ": *
#import "./_helpers.typ": showcase, join_lines

= Defaults

#showcase(
  "constructor defaults (core nodes + arrows)",
  join_lines((
    "#let make-dataset = set-dataset-defaults(options: (",
    "  images: 3,",
    "  image-size: (1.4, 1.8),",
    "  image-spacing: 0.14,",
    "  title-position: \"below\",",
    "))",
    "#let make-trapezoid = set-trapezoid-defaults(options: (",
    "  width: 2.2,",
    "  big-half: 1.25,",
    "  small-half: 0.65,",
    "))",
    "#let make-box = set-box-defaults(options: (",
    "  min-w: 2.1,",
    "  min-h: 1.5,",
    "  pad-x: 0.55,",
    "))",
    "#let make-arrow = set-arrow-defaults(options: (",
    "  spacing: 0.48,",
    "  label-gap: 0.32,",
    "))",
    "",
    "#graph-canvas(length: 0.58cm, {",
    "  let ds = make-dataset(\"Input\", pos: (1.0, 0.0))",
    "  let enc = make-trapezoid(\"Encoder\", subtitle: \"Conv\", after: ds, gap: 0.9)",
    "  let head = make-box(\"Head\", subtitle: \"MLP\", after: enc, gap: 0.9)",
    "  let aux = make-dataset(\"Aux\", images: 2, image-size: (1.0, 1.3), pos: (5.2, 1.7))",
    "",
    "  draw-node(ds)",
    "  draw-node(enc)",
    "  draw-node(head)",
    "  draw-node(aux)",
    "",
    "  let arrows = (",
    "    make-arrow(ds, enc, from-outer: true, label: [input]),",
    "    make-arrow(enc, head, label: [features]),",
    "    make-arrow(aux, head, out-side: \"right\", in-side: \"top\", from-outer: true, mode: \"hv\", label: [aux]),",
    "  )",
    "  draw-arrows(arrows)",
    "})",
  )),
  {
    let make-dataset = set-dataset-defaults(options: (
      images: 3,
      image-size: (1.4, 1.8),
      image-spacing: 0.14,
      title-position: "below",
    ))
    let make-trapezoid = set-trapezoid-defaults(options: (
      width: 2.2,
      big-half: 1.25,
      small-half: 0.65,
    ))
    let make-box = set-box-defaults(options: (
      min-w: 2.1,
      min-h: 1.5,
      pad-x: 0.55,
    ))
    let make-arrow = set-arrow-defaults(options: (
      spacing: 0.48,
      label-gap: 0.32,
    ))

    graph-canvas(length: 0.58cm, {
      let ds = make-dataset("Input", pos: (1.0, 0.0))
      let enc = make-trapezoid("Encoder", subtitle: "Conv", after: ds, gap: 0.9)
      let head = make-box("Head", subtitle: "MLP", after: enc, gap: 0.9)
      let aux = make-dataset("Aux", images: 2, image-size: (1.0, 1.3), pos: (5.2, 1.7))

      draw-node(ds)
      draw-node(enc)
      draw-node(head)
      draw-node(aux)

      let arrows = (
        make-arrow(ds, enc, from-outer: true, label: [input]),
        make-arrow(enc, head, label: [features]),
        make-arrow(aux, head, out-side: "right", in-side: "top", from-outer: true, mode: "hv", label: [aux]),
      )
      draw-arrows(arrows)
    })
  }
)

#showcase(
  "image + latent defaults",
  join_lines((
    "#let make-image-node = set-image-node-defaults(options: (",
    "  src: \"/assets/test.jpg\",",
    "  image-width: 1.9,",
    "  image-height: 1.9,",
    "  image-pad: 0.06,",
    "  title-position: \"below\",",
    "))",
    "#let make-image-dataset = set-image-dataset-defaults(options: (",
    "  src: \"/assets/test.jpg\",",
    "  images: 3,",
    "  image-width: 1.4,",
    "  image-height: 1.9,",
    "  image-spacing: 0.14,",
    "  image-pad: 0.04,",
    "  title-position: \"below\",",
    "))",
    "#let make-latent-space = set-latent-space-defaults(options: (",
    "  width: 0.75,",
    "  height: 2.7,",
    "  title-position: \"below\",",
    "))",
    "#let make-arrow = set-arrow-defaults(options: (",
    "  spacing: 0.42,",
    "  label-gap: 0.30,",
    "))",
    "",
    "#graph-canvas(length: 0.58cm, {",
    "  let img = make-image-node(\"Image\", pos: (1.0, 0.0))",
    "  let ds = make-image-dataset(\"Dataset\", after: img, gap: 1.0)",
    "  let latent = make-latent-space(\"Latent\", after: ds, gap: 1.0)",
    "  let skip = make-image-dataset(\"Skip\", images: 2, image-width: 1.0, image-height: 1.3, pos: (4.7, 1.7))",
    "",
    "  draw-node(img)",
    "  draw-node(ds)",
    "  draw-node(latent)",
    "  draw-node(skip)",
    "",
    "  let arrows = (",
    "    make-arrow(img, ds, label: [samples]),",
    "    make-arrow(ds, latent, from-outer: true, label: [encode]),",
    "    make-arrow(skip, latent, out-side: \"right\", in-side: \"top\", from-outer: true, mode: \"hv\", label: [skip]),",
    "  )",
    "  draw-arrows(arrows)",
    "})",
  )),
  {
    let make-image-node = set-image-node-defaults(options: (
      src: "/assets/test.jpg",
      image-width: 1.9,
      image-height: 1.9,
      image-pad: 0.06,
      title-position: "below",
    ))
    let make-image-dataset = set-image-dataset-defaults(options: (
      src: "/assets/test.jpg",
      images: 3,
      image-width: 1.4,
      image-height: 1.9,
      image-spacing: 0.14,
      image-pad: 0.04,
      title-position: "below",
    ))
    let make-latent-space = set-latent-space-defaults(options: (
      width: 0.75,
      height: 2.7,
      title-position: "below",
    ))
    let make-arrow = set-arrow-defaults(options: (
      spacing: 0.42,
      label-gap: 0.30,
    ))

    graph-canvas(length: 0.58cm, {
      let img = make-image-node("Image", pos: (1.0, 0.0))
      let ds = make-image-dataset("Dataset", after: img, gap: 1.0)
      let latent = make-latent-space("Latent", after: ds, gap: 1.0)
      let skip = make-image-dataset("Skip", images: 2, image-width: 1.0, image-height: 1.3, pos: (4.7, 1.7))

      draw-node(img)
      draw-node(ds)
      draw-node(latent)
      draw-node(skip)

      let arrows = (
        make-arrow(img, ds, label: [samples]),
        make-arrow(ds, latent, from-outer: true, label: [encode]),
        make-arrow(skip, latent, out-side: "right", in-side: "top", from-outer: true, mode: "hv", label: [skip]),
      )
      draw-arrows(arrows)
    })
  }
)