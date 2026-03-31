#import "../lib.typ": *
#import "./_helpers.typ": showcase, join_lines

= Emoji

#showcase(
  "draw-node-emoji",
  join_lines((
    "#graph-canvas({",
    "  let lock = make-box(\"Secure Box\", pos: (4.0, 0.0))",
    "  draw-node(lock)",
    "",
    "  draw-node-emoji(",
    "    lock,",
    "    kind: \"lock-closed\",",
    "    place: \"top\",",
    "    gap: 0.6,",
    "    shift: (0.2, 0.0),",
    "    size: 1.0em,",
    "    color: rgb(\"#333333\"),",
    "    use-outer: false,",
    "    key-state: \"encrypted\",",
    "    state-text: \"enc\",",
    "    state-size: 0.38em,",
    "    state-gap: 0.25,",
    "    state-position: \"above\",",
    "  )",
    "",
    "  draw-node-emoji(",
    "    lock,",
    "    kind: \"key\",",
    "    place: \"right\",",
    "    key-state: \"decrypted\",",
    "  )",
    "",
    "  draw-node-emoji(",
    "    lock,",
    "    kind: \"custom\",",
    "    emoji: [X],",
    "    place: \"under\",",
    "  )",
    "})",
  )),
  {
    graph-canvas({
      let lock = make-box("Secure Box", pos: (4.0, 0.0))
      draw-node(lock)

      draw-node-emoji(
        lock,
        kind: "lock-closed",
        place: "top",
        gap: 0.6,
        shift: (0.2, 0.0),
        size: 1.0em,
        color: rgb("#333333"),
        use-outer: false,
        key-state: "encrypted",
        state-text: "enc",
        state-size: 0.38em,
        state-gap: 0.25,
        state-position: "above",
      )

      draw-node-emoji(
        lock,
        kind: "key",
        place: "right",
        key-state: "decrypted",
      )

      draw-node-emoji(
        lock,
        kind: "custom",
        emoji: [X],
        place: "under",
      )
    })
  }
)
