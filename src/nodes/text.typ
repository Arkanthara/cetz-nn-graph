#import "../internal/geometry.typ": resolve-node-center

/// Build a text-only node.
#let make-text(
  title,
  subtitle: none,
  legend: none,
  legend-position: "below",
  size: none,
  pos: none,
  after: none,
  gap: 1.0,
  y: none,
  title-size: 0.62em,
  subtitle-size: 0.52em,
  legend-size: 0.48em,
  wrap-lines: 2,
  title-position: "inside",
  pad-x: 0.35,
  min-w: 0.9,
  min-h: 0.6,
) = {
  let text-len(txt) = {
    if txt == none { 0 } else if type(txt) == str { txt.clusters().len() } else { 0 }
  }
  let l1 = text-len(title)
  let l2 = text-len(subtitle)
  let longest = calc.max(l1, l2)
  let auto-w = calc.max(min-w, longest * 0.17 + 2 * pad-x)
  let auto-h = if subtitle == none { min-h } else { min-h + 0.45 }
  let (w, h) = if size == none {
    (auto-w, auto-h)
  } else if type(size) == array {
    size
  } else {
    (size, size)
  }

  let (cx, cy) = resolve-node-center(pos, after, w, gap: gap, y: y, default-x: 1.0)

  (
    kind: "text",
    cx: cx,
    cy: cy,
    w: w,
    h: h,
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
