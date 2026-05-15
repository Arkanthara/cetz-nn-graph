#import "../lib.typ": *

#let nodes = (
  dataset("a", title: [Input A], pos: (0, -1)),
  dataset("b", title: [Input B], pos: (0, 1)),
  encoder("enc-a", title: [Shared encoder], pos: right-of("a")),
  encoder("enc-b", title: [Shared encoder], pos: right-of("b")),
  embedding("embedding", title: [Embedding], pos: (2, 0)),
  module("distance", title: [Distance], pos: right-of("embedding")),
  group("shared", ("enc-a", "enc-b"), title: [Shared weights]),
)

#let edges = (
  ml-edge("a", "enc-a", label: [input]),
  ml-edge("b", "enc-b", label: [input]),
  ml-edge("enc-a", "embedding", label: [embed]),
  ml-edge("enc-b", "embedding", label: [embed]),
  ml-edge("embedding", "distance", label: [compare]),
)

#ml-diagram(nodes, edges: edges, layout: false)
