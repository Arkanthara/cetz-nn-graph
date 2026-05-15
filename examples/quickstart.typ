#import "../lib.typ": *

#let nodes = (
  dataset("images", title: [Image dataset]),
  encoder("encoder", title: [Feature encoder], subtitle: [Conv stack]),
  module("head", title: [Head], subtitle: [Prediction]),
)

#let edges = (
  ml-edge("images", "encoder", label: [input]),
  ml-edge("encoder", "head", label: [features]),
)

#ml-diagram(nodes, edges: edges, layout: "pipeline")
