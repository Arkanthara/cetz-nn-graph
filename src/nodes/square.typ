#import "box.typ": make-box

/// Build a square node.
#let make-square(
  title,
  subtitle: none,
  legend: none,
  legend-position: "below",
  size: 2.2,
  pos: none,
  after: none,
  gap: 1.0,
  y: none,
  color: rgb("#a0b8f5"),
  title-size: 0.62em,
  subtitle-size: 0.52em,
  legend-size: 0.48em,
  wrap-lines: 2,
  title-position: "inside",
) = {
  make-box(
    title,
    subtitle: subtitle,
    legend: legend,
    legend-position: legend-position,
    size: (size, size),
    pos: pos,
    after: after,
    gap: gap,
    y: y,
    color: color,
    title-size: title-size,
    subtitle-size: subtitle-size,
    legend-size: legend-size,
    wrap-lines: wrap-lines,
    title-position: title-position,
  )
}
