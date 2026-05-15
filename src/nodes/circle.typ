#import "../internal/geometry.typ": resolve-node-center

/// Build a circular node.
#let make-circle(
  title,
  subtitle: none,
  legend: none,
  legend-position: "below",
  radius: 1.1,
  pos: none,
  after: none,
  gap: 1.0,
  y: none,
  color: rgb("#f0c2a0"),
  title-size: 0.62em,
  subtitle-size: 0.52em,
  legend-size: 0.48em,
  wrap-lines: 2,
  title-position: "inside",
) = {
  let d = radius * 2
  let (cx, cy) = resolve-node-center(pos, after, d, gap: gap, y: y, default-x: 6.5)

  (
    kind: "circle",
    cx: cx,
    cy: cy,
    w: d,
    h: d,
    r: radius,
    color: color,
    title: title,
    subtitle: subtitle,
    legend: legend,
    legend-position: legend-position,
    title-size: title-size,
    subtitle-size: subtitle-size,
    legend-size: legend-size,
    wrap-lines: wrap-lines,
    title-position: title-position,
  )
}
