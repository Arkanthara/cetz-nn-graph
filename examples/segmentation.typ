#import "../lib.typ": *

#let nodes = (
  image-node("input", title: [Input image], src: "/assets/test.jpg"),
  encoder("enc", title: [Encoder], subtitle: [Downsample]),
  transformer("context", title: [Context], subtitle: [Global features]),
  decoder("dec", title: [Decoder], subtitle: [Upsample]),
  image-node("mask", title: [Segmentation mask], src: "/assets/test.jpg"),
)

#let edges = (
  ml-edge("input", "enc", label: [input]),
  ml-edge("enc", "context", label: [encode]),
  ml-edge("context", "dec", label: [decode]),
  ml-edge("dec", "mask", label: [mask]),
)

#ml-diagram(nodes, edges: edges, layout: "pipeline")
