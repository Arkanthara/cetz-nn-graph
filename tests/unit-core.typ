#import "../lib.typ": *
#import "./_helpers.typ": showcase, join_lines

= Unit: core specs and positioning

#assert.eq(fletcher-version, "0.5.9")
#assert.eq(as-node-id("Feature Encoder"), "Feature-Encoder")
#assert.eq(node-ref("encoder"), <encoder>)
#assert.eq(anchor-ref("encoder", side: "right"), <encoder.east>)
#assert.eq(right-of("encoder"), (rel: (1, 0), to: <encoder>))
#assert.eq(offset-pos((2, 3), by: (0.5, -1)), (2.5, 2))

#let n = ml-node("encoder", title: [Encoder], subtitle: [Conv], pos: (2, 0), size: (2, 1))
#assert.eq(n.id, "encoder")
#assert.eq(n.pos, (2, 0))
#assert.eq(n.kind, "module")
#assert.eq(n.size, (1.44cm, 0.72cm))

#let e = ml-edge("encoder", "head", label: [features], from-side: "right", to-side: "left")
#assert.eq(e.from, "encoder")
#assert.eq(e.to, "head")
#assert.eq(e.kind, "flow")
#assert.eq(e.mark, "-|>")

#showcase(
  "Core helpers",
  join_lines((
    "#node-ref(\"encoder\")",
    "#anchor-ref(\"encoder\", side: \"right\")",
    "#right-of(\"encoder\")",
  )),
  text(repr(node-ref("encoder")) + "\n" + repr(anchor-ref("encoder", side: "right")) + "\n" + repr(right-of("encoder"))),
)
