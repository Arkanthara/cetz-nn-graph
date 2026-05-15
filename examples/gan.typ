#import "../lib.typ": *

#let nodes = (
  image-dataset("real", title: [Real images], src: "/assets/test.jpg", pos: (0, -1.2)),
  vector("noise", title: [Noise z], pos: (0, 1.2)),
  decoder("generator", title: [Generator], pos: right-of("noise")),
  image-dataset("fake", title: [Fake images], src: "/assets/test.jpg", pos: right-of("generator")),
  encoder("discriminator", title: [Discriminator], pos: (3, 0)),
  io-node("score", title: [Score], pos: right-of("discriminator")),
)

#let edges = (
  ml-edge("noise", "generator", label: [noise]),
  ml-edge("generator", "fake", label: [fake]),
  ml-edge("fake", "discriminator", label: [fake]),
  ml-edge("real", "discriminator", from-side: "right", to-side: "top", label: [real]),
  ml-edge("discriminator", "score", label: [score]),
)

#ml-diagram(nodes, edges: edges, layout: false)
