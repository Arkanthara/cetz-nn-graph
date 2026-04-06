#import "../lib.typ": *
#import "./_helpers.typ": showcase, join_lines

= Node constructors

#showcase(
  "make-dataset",
  join_lines((
    "#graph-canvas({",
    "  let ds1 = make-dataset(",
    "    \"Image\\nDataset\",",
    "    images: 3,",
    "    image-size: (1.9, 2.3),",
    "    image-spacing: 0.22,",
    "    pos: (1.0, 0.0),",
    "  )",
    "  let ds2 = make-dataset(",
    "    \"Features\",",
    "    subtitle: \"H x W x C\",",
    "    legend: \"latent tensor\",",
    "    legend-position: \"top\",",
    "    images: 6,",
    "    image-size: (1.2, 1.6),",
    "    image-spacing: 0.12,",
    "    title-position: \"below\",",
    "    after: ds1,",
    "    gap: 1.2,",
    "    color: rgb(\"#fcd97a\"),",
    "    title-size: 0.52em,",
    "    subtitle-size: 0.44em,",
    "    legend-size: 0.42em,",
    "    wrap-lines: 2,",
    "  )",
    "  let ds3 = make-dataset(",
    "    \"Long Dataset Title\",",
    "    title-truncate: true,",
    "    max-title-chars: 10,",
    "    after: ds2,",
    "    gap: 1.2,",
    "    y: -1.4,",
    "  )",
    "",
    "  draw-node(ds1)",
    "  draw-node(ds2)",
    "  draw-node(ds3)",
    "})",
  )),
  {
    graph-canvas({
      let ds1 = make-dataset(
        "Image\nDataset",
        images: 3,
        image-size: (1.9, 2.3),
        image-spacing: 0.22,
        pos: (1.0, 0.0),
      )
      let ds2 = make-dataset(
        "Features",
        subtitle: "H x W x C",
        legend: "latent tensor",
        legend-position: "top",
        images: 6,
        image-size: (1.2, 1.6),
        image-spacing: 0.12,
        title-position: "below",
        after: ds1,
        gap: 1.2,
        color: rgb("#fcd97a"),
        title-size: 0.52em,
        subtitle-size: 0.44em,
        legend-size: 0.42em,
        wrap-lines: 2,
      )
      let ds3 = make-dataset(
        "Long Dataset Title",
        title-truncate: true,
        max-title-chars: 10,
        after: ds2,
        gap: 1.2,
        y: -1.4,
      )

      draw-node(ds1)
      draw-node(ds2)
      draw-node(ds3)
    })
  }
)

#showcase(
  "make-trapezoid",
  join_lines((
    "#graph-canvas({",
    "  let enc = make-trapezoid(",
    "    \"Encoder\",",
    "    subtitle: \"Downsample\",",
    "    legend: \"stage 1\",",
    "    legend-position: \"top\",",
    "    mode: \"encoder\",",
    "    width: 2.8,",
    "    big-half: 1.65,",
    "    small-half: 0.80,",
    "    pos: (2.0, 0.0),",
    "    color: rgb(\"#b0dba0\"),",
    "    title-size: 0.66em,",
    "    subtitle-size: 0.54em,",
    "    legend-size: 0.48em,",
    "    wrap-lines: 2,",
    "  )",
    "  let dec = make-trapezoid(",
    "    \"Decoder\",",
    "    subtitle: \"Upsample\",",
    "    legend: \"stage 2\",",
    "    legend-position: \"below\",",
    "    mode: \"decoder\",",
    "    width: 2.8,",
    "    big-half: 1.65,",
    "    small-half: 0.80,",
    "    after: enc,",
    "    gap: 1.4,",
    "    y: -1.6,",
    "    color: rgb(\"#b0dba0\"),",
    "  )",
    "",
    "  draw-node(enc)",
    "  draw-node(dec)",
    "})",
  )),
  {
    graph-canvas({
      let enc = make-trapezoid(
        "Encoder",
        subtitle: "Downsample",
        legend: "stage 1",
        legend-position: "top",
        mode: "encoder",
        width: 2.8,
        big-half: 1.65,
        small-half: 0.80,
        pos: (2.0, 0.0),
        color: rgb("#b0dba0"),
        title-size: 0.66em,
        subtitle-size: 0.54em,
        legend-size: 0.48em,
        wrap-lines: 2,
      )
      let dec = make-trapezoid(
        "Decoder",
        subtitle: "Upsample",
        legend: "stage 2",
        legend-position: "below",
        mode: "decoder",
        width: 2.8,
        big-half: 1.65,
        small-half: 0.80,
        after: enc,
        gap: 1.4,
        y: -1.6,
        color: rgb("#b0dba0"),
      )

      draw-node(enc)
      draw-node(dec)
    })
  }
)

#showcase(
  "make-box",
  join_lines((
    "#graph-canvas({",
    "  let auto_box = make-box(",
    "    \"Auto Box\",",
    "    subtitle: \"Uses pad\",",
    "    legend: \"auto size\",",
    "    legend-position: \"top\",",
    "    pad-x: 0.7,",
    "    min-w: 2.6,",
    "    min-h: 1.8,",
    "    pos: (2.0, 0.0),",
    "  )",
    "  let manual = make-box(",
    "    \"Manual Box\",",
    "    subtitle: \"Fixed\",",
    "    size: (3.0, 2.0),",
    "    after: auto_box,",
    "    gap: 1.4,",
    "    color: rgb(\"#a0b8f5\"),",
    "    wrap-lines: 2,",
    "  )",
    "",
    "  draw-node(auto_box)",
    "  draw-node(manual)",
    "})",
  )),
  {
    graph-canvas({
      let auto_box = make-box(
        "Auto Box",
        subtitle: "Uses pad",
        legend: "auto size",
        legend-position: "top",
        pad-x: 0.7,
        min-w: 2.6,
        min-h: 1.8,
        pos: (2.0, 0.0),
      )
      let manual = make-box(
        "Manual Box",
        subtitle: "Fixed",
        size: (3.0, 2.0),
        after: auto_box,
        gap: 1.4,
        color: rgb("#a0b8f5"),
        wrap-lines: 2,
      )

      draw-node(auto_box)
      draw-node(manual)
    })
  }
)

#showcase(
  "make-image-node",
  join_lines((
    "#graph-canvas({",
    "  let from_src = make-image-node(",
    "    \"Single\\nImage\",",
    "    src: \"/assets/test.jpg\",",
    "    image-width: 2.2,",
    "    image-height: 2.2,",
    "    image-pad: 0.08,",
    "    image-shift-x: 0.18,",
    "    image-shift-y: -0.12,",
    "    unit: 0.72cm,",
    "    title-position: \"below\",",
    "    pos: (2.0, 0.0),",
    "  )",
    "  let from_img = make-image-node(",
    "    \"Prebuilt\\nimg\",",
    "    img: image(\"/assets/sample.svg\", width: 5cm),",
    "    image-size: (1.8, 2.2),",
    "    image-pad: 0.08,",
    "    image-shift-x: -0.1,",
    "    unit: 0.72cm,",
    "    title-position: \"below\",",
    "    after: from_src,",
    "    gap: 1.4,",
    "  )",
    "",
    "  draw-node(from_src)",
    "  draw-node(from_img)",
    "})",
  )),
  {
    graph-canvas({
      let from_src = make-image-node(
        "Single\nImage",
        src: "/assets/test.jpg",
        image-width: 2.2,
        image-height: 2.2,
        image-pad: 0.08,
        image-shift-x: 0.18,
        image-shift-y: -0.12,
        unit: 0.72cm,
        title-position: "below",
        pos: (2.0, 0.0),
      )
      let from_img = make-image-node(
        "Prebuilt\nimg",
        img: image("/assets/sample.svg", width: 5cm),
        image-size: (1.8, 2.2),
        image-pad: 0.08,
        image-shift-x: -0.1,
        unit: 0.72cm,
        title-position: "below",
        after: from_src,
        gap: 1.4,
      )

      draw-node(from_src)
      draw-node(from_img)
    })
  }
)

#showcase(
  "make-image-dataset",
  join_lines((
    "#graph-canvas({",
    "  let ds = make-image-dataset(",
    "    \"Image\\nDataset\",",
    "    src: \"/assets/test.jpg\",",
    "    images: 4,",
    "    image-width: 1.6,",
    "    image-height: 2.1,",
    "    image-spacing: 0.16,",
    "    image-pad: 0.08,",
    "    image-shift-x: -0.22,",
    "    image-shift-y: 0.08,",
    "    unit: 0.72cm,",
    "    title-position: \"below\",",
    "    pos: (2.0, 0.0),",
    "  )",
    "",
    "  draw-node(ds)",
    "})",
  )),
  {
    graph-canvas({
      let ds = make-image-dataset(
        "Image\nDataset",
        src: "/assets/test.jpg",
        images: 4,
        image-width: 1.6,
        image-height: 2.1,
        image-spacing: 0.16,
        image-pad: 0.08,
        image-shift-x: -0.22,
        image-shift-y: 0.08,
        unit: 0.72cm,
        title-position: "below",
        pos: (2.0, 0.0),
      )

      draw-node(ds)
    })
  }
)

#showcase(
  "make-latent-space",
  join_lines((
    "#graph-canvas({",
    "  let latent = make-latent-space(",
    "    \"Latent\\nSpace\",",
    "    height: 3.1,",
    "    pos: (2.0, 0.0),",
    "  )",
    "",
    "  draw-node(latent)",
    "})",
  )),
  {
    graph-canvas({
      let latent = make-latent-space(
        "Latent\nSpace",
        height: 3.1,
        pos: (2.0, 0.0),
      )

      draw-node(latent)
    })
  }
)

#showcase(
  "draw-nodes helper",
  join_lines((
    "#graph-canvas({",
    "  let a = make-box(\"A\", pos: (1.2, 0.0))",
    "  let b = make-box(\"B\", after: a, gap: 1.2)",
    "  let c = make-box(\"C\", pos: (1.2, -2.0))",
    "",
    "  draw-nodes((a, b, c))",
    "})",
  )),
  {
    graph-canvas({
      let a = make-box("A", pos: (1.2, 0.0))
      let b = make-box("B", after: a, gap: 1.2)
      let c = make-box("C", pos: (1.2, -2.0))

      draw-nodes((a, b, c))
    })
  }
)
