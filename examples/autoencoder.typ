#import "../lib.typ": *

#let nodes = (
  image-dataset(
    "input",
    title: [Input images],
    src: "/assets/test.jpg",
    stack: 3,
    image-size: (1.9, 2.1),
  ),
  encoder("enc", title: [Encoder], subtitle: [Downsample]),
  tensor("latent", title: [Latent space], stack: 1, size: (0.85, 2.8)),
  decoder("dec", title: [Decoder], subtitle: [Upsample]),
  image-dataset(
    "output",
    title: [Reconstruction],
    src: "/assets/test.jpg",
    stack: 3,
    image-size: (1.9, 2.1),
  ),
)

#let edges = (
  ml-edge("input", "enc", label: [input]),
  ml-edge("enc", "latent", label: [encode]),
  ml-edge("latent", "dec", label: [decode]),
  ml-edge("dec", "output", label: [output]),
)

#ml-diagram(nodes, edges: edges, layout: "pipeline")
