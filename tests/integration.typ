#import "../lib.typ": *
#import "./_helpers.typ": showcase, join_lines

= Integration: ML workflows

#let multimodal-nodes = (
  image-dataset("images", title: [Images], src: "/assets/test.jpg"),
  dataset("text", title: [Text tokens], samples: [tokens]),
  encoder("vision", title: [Vision encoder]),
  encoder("language", title: [Text encoder]),
  transformer("fusion", title: [Fusion transformer]),
  io-node("answer", title: [Answer]),
  group("encoders", ("vision", "language"), title: [Encoders]),
)

#let multimodal-edges = (
  ml-edge("images", "vision", label: [pixels]),
  ml-edge("text", "language", label: [ids]),
  ml-edge("vision", "fusion", label: [visual tokens]),
  ml-edge("language", "fusion", label: [text tokens]),
  ml-edge("fusion", "answer", label: [logits]),
)

#showcase(
  "Multimodal DAG",
  join_lines((
    "#ml-diagram(multimodal-nodes, edges: multimodal-edges, layout: \"dag\")",
  )),
  ml-diagram(multimodal-nodes, edges: multimodal-edges, layout: "dag"),
)

#let train-nodes = (
  dataset("raw", title: [Raw data]),
  operation("prep", title: [Preprocess]),
  batch("batches", title: [Batches]),
  module("model", title: [Model]),
  operation("loss", title: [Loss]),
  module("optim", title: [Optimizer]),
)
#let train-edges = (
  ml-edge("raw", "prep"),
  ml-edge("prep", "batches"),
  ml-edge("batches", "model"),
  ml-edge("model", "loss"),
  ml-edge("loss", "optim"),
  ml-edge("optim", "model", bend: -35deg, label: [update], crossing: true),
)

#showcase(
  "Training loop",
  join_lines((
    "#ml-diagram(train-nodes, edges: train-edges, layout: \"pipeline\")",
  )),
  ml-diagram(train-nodes, edges: train-edges, layout: "pipeline"),
)
