#set page(margin: 18pt)
#set text(size: 10pt)

#let join_lines(lines) = lines.join("\n")

#let showcase(title, code, body) = {
  heading(level: 2)[#title]
  grid(
    columns: (1fr, 1fr),
    column-gutter: 10pt,
    row-gutter: 6pt,
    [#text(weight: "bold")[Code]],
    [#text(weight: "bold")[Output]],
    [#raw(code, block: true, lang: "typ")],
    [#box(stroke: (paint: rgb("#dddddd"), thickness: 0.4pt), inset: 4pt)[#body]],
  )
}
