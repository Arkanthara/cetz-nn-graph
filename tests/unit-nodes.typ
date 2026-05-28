#import "../lib.typ": *
#import "./_helpers.typ": showcase, join_lines

= Unit: ML nodes

#let ds = dataset("train", title: [Training data], samples: [10k], stack: 4)
#assert.eq(ds.kind, "dataset")
#assert.eq(ds.role, "data")
#assert.eq(ds.extrude, (0, 2, 4, 6))

#let batch-node = batch("batch", title: [Batch])
#assert.eq(batch-node.kind, "dataset")

#let t = tensor("features", title: [Features], dims: [$B times C times H times W$])
#assert.eq(t.kind, "dataset")
#assert.eq(t.role, "data")

#let enc = encoder("enc", title: [Encoder])
#let dec = decoder("dec", title: [Decoder])
#let attn = attention("attn", title: [Attention])
#let tr = transformer("block", title: [Transformer block])
#assert.eq(enc.kind, "module")
#assert.eq(dec.kind, "module")
#assert.eq(attn.kind, "module")
#assert.eq(tr.kind, "module")

#let g = group("model", ("enc", "dec"), title: [Model])
#assert.eq(g.kind, "group")
#assert.eq(g.enclose, (<enc>, <dec>))
#assert.eq(g.layer, -1)

#let tbl = table-node(
  "metrics",
  rows: 2,
  columns: 2,
  cells: ([A], [B], [C], [D]),
)
#assert.eq(tbl.kind, "table")
#assert.eq(tbl.role, "data")

#showcase(
  "Node constructors",
  join_lines((
    "#dataset(\"train\", title: [Training data])",
    "#encoder(\"enc\", title: [Encoder])",
    "#group(\"model\", (\"enc\", \"dec\"), title: [Model])",
  )),
  text((ds.kind, enc.kind, g.kind).join(" / ")),
)
