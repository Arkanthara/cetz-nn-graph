#import "../lib.typ": *

#let nodes = (
  dataset("train", title: [Training images]),
  encoder("encoder", title: [Feature encoder], subtitle: [Conv stack]),
  tensor("features", title: [Feature tensor], dims: [$B times C times H times W$]),
  module("classifier", title: [Classifier], subtitle: [MLP]),
  io-node("scores", title: [Class scores]),
)

#let edges = (
  ml-edge("train", "encoder", label: [input]),
  ml-edge("encoder", "features", label: [features]),
  ml-edge("features", "classifier", label: [flatten]),
  ml-edge("classifier", "scores", label: [logits]),
)

#ml-diagram(nodes, edges: edges, layout: "pipeline")
