#import "../lib.typ": *
#import "./_helpers.typ": showcase, join_lines

= Unit: Fletcher render

#let nodes = (
  dataset("input", title: [Input]),
  encoder("enc", title: [Encoder]),
  tensor("latent", title: [Latent], stack: 1),
  decoder("dec", title: [Decoder]),
  io-node("out", title: [Output]),
)
#let edges = (
  ml-edge("input", "enc", label: [input]),
  ml-edge("enc", "latent", label: [encode]),
  ml-edge("latent", "dec", label: [decode]),
  ml-edge("dec", "out", label: [output]),
)

#showcase(
  "ml-diagram pipeline",
  join_lines((
    "#ml-diagram(nodes, edges: edges, layout: \"pipeline\")",
  )),
  ml-diagram(nodes, edges: edges, layout: "pipeline"),
)

#showcase(
  "Fletcher anchors",
  join_lines((
    "#ml-edge(\"input\", \"latent\", from-side: \"bottom\", to-side: \"top\")",
  )),
  ml-diagram(
    nodes,
    edges: edges + (ml-edge("input", "latent", from-side: "bottom", to-side: "top", bend: 25deg, label: [skip]),),
    layout: "pipeline",
  ),
)
