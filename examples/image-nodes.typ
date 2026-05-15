#import "../lib.typ": *

#let nodes = (
  image-node(
    "image",
    title: [Single image],
    src: "/assets/test.jpg",
    image-size: (2.1, 1.8),
  ),
  image-dataset(
    "dataset",
    title: [Image dataset],
    src: "/assets/test.jpg",
    stack: 4,
    image-size: (1.5, 1.9),
  ),
  tensor("latent", title: [Latent space], stack: 1, size: (0.85, 2.6)),
)

#let edges = (
  ml-edge("image", "dataset", label: [samples]),
  ml-edge("dataset", "latent", label: [encode]),
)

#ml-diagram(nodes, edges: edges, layout: "pipeline")
