#import "../lib.typ": *
#import "./_helpers.typ": showcase, join_lines

= Visual smoke tests

These pages are compiled by CI. They act as regression fixtures for Fletcher rendering,
node styling, grouped modules, image content, and mixed manual/automatic layout.

#let a = image-node("sample", title: [Sample], src: "/assets/test.jpg", pos: (0, 0))
#let b = encoder("enc", title: [Encoder])
#let c = attention("attn", title: [Attention], pos: right-of("enc", by: 1, dy: -0.75))
#let d = decoder("dec", title: [Decoder])
#let e = image-node("pred", title: [Prediction], src: "/assets/test.jpg")
#let g = group("model", ("enc", "attn", "dec"), title: [Hybrid model])

#let nodes = (a, b, c, d, e, g)
#let edges = (
  ml-edge("sample", "enc", label: [input]),
  ml-edge("enc", "attn", label: [query/key/value]),
  ml-edge("attn", "dec", label: [context]),
  ml-edge("dec", "pred", label: [output]),
  ml-edge("sample", "pred", from-side: "bottom", to-side: "bottom", bend: 38deg, label: [skip]),
)

#showcase(
  "Mixed manual and auto layout",
  join_lines((
    "#ml-diagram(nodes, edges: edges, layout: \"dag\")",
  )),
  ml-diagram(nodes, edges: edges, layout: "dag"),
)
