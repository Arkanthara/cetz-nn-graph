#import "../lib.typ": *
#import "./_helpers.typ": showcase, join_lines

= String utilities

#showcase(
  "clip-str",
  join_lines((
    "#clip-str(\"Computed Depth Maps\", 8)",
    "#clip-str(\"Depth\", 10)",
  )),
  {
  text(clip-str("Computed Depth Maps", 8) + "\n" + clip-str("Depth", 10))
})

#showcase(
  "truncate-title",
  join_lines((
    "#truncate-title(\"Very long title\", enabled: true, max-chars: 8)",
    "#truncate-title(\"Very long title\", enabled: false)",
    "#truncate-title(\"Long\", enabled: true, max-chars: 3)",
  )),
  {
  text(
    truncate-title("Very long title", enabled: true, max-chars: 8)
      + "\n" + truncate-title("Very long title", enabled: false)
      + "\n" + truncate-title("Long", enabled: true, max-chars: 3)
  )
})

#showcase(
  "fit-lines",
  join_lines((
    "#fit-lines(\"Line 1\\nLine 2\", max-chars: 6, max-lines: 2)",
    "#fit-lines(\"No auto wrapping\", max-chars: 6, max-lines: 1)",
  )),
  {
  text(
    fit-lines("Line 1\nLine 2", max-chars: 6, max-lines: 2)
      + "\n" + fit-lines("No auto wrapping", max-chars: 6, max-lines: 1)
  )
})
