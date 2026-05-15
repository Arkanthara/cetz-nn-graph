#import "@preview/cetz:0.4.2": draw
#import "../internal/geometry.typ": node-anchor, node-edge, node-size, side-dir

#let same-point(a, b) = {
  calc.abs(a.at(0) - b.at(0)) < 0.001 and calc.abs(a.at(1) - b.at(1)) < 0.001
}

#let side-axis(side) = {
  if side == "left" or side == "right" { "y" } else { "x" }
}

#let axis-value(node, axis) = {
  if axis == "x" { node.cx } else { node.cy }
}

#let side-point(node, side, t, outer: false, outer-value: none) = {
  let (w, h) = node-size(node, outer: outer)
  let tt = calc.max(0.0, calc.min(1.0, t))

  if side == "left" or side == "right" {
    (
      node-edge(node, side: side, outer: outer, outer-value: outer-value),
      node.cy - h / 2 + tt * h,
    )
  } else {
    (
      node.cx - w / 2 + tt * w,
      node-edge(node, side: side, outer: outer, outer-value: outer-value),
    )
  }
}

#let sign-num(v) = {
  if v > 0 { 1 } else if v < 0 { -1 } else { 0 }
}

#let rounded-points(points, radius, steps: 4) = {
  if radius == none {
    points
  } else if not (type(radius) == int or type(radius) == float) {
    points
  } else if radius <= 0 or points.len() < 3 {
    points
  } else {
    let out = (points.first(),)
    for i in range(1, points.len() - 1) {
      let prev = points.at(i - 1)
      let curr = points.at(i)
      let next = points.at(i + 1)

      let dx1 = curr.at(0) - prev.at(0)
      let dy1 = curr.at(1) - prev.at(1)
      let dx2 = next.at(0) - curr.at(0)
      let dy2 = next.at(1) - curr.at(1)

      let axis1 = if calc.abs(dx1) > calc.abs(dy1) { "x" } else { "y" }
      let axis2 = if calc.abs(dx2) > calc.abs(dy2) { "x" } else { "y" }

      if (dx1 == 0 and dy1 == 0) or (dx2 == 0 and dy2 == 0) or axis1 == axis2 {
        out.push(curr)
      } else {
        let len1 = if axis1 == "x" { calc.abs(dx1) } else { calc.abs(dy1) }
        let len2 = if axis2 == "x" { calc.abs(dx2) } else { calc.abs(dy2) }
        let rr = calc.min(radius, len1 / 2, len2 / 2)

        if rr <= 0 {
          out.push(curr)
        } else {
          let sx1 = sign-num(dx1)
          let sy1 = sign-num(dy1)
          let sx2 = sign-num(dx2)
          let sy2 = sign-num(dy2)

          let pin = (curr.at(0) - sx1 * rr, curr.at(1) - sy1 * rr)
          let pout = (curr.at(0) + sx2 * rr, curr.at(1) + sy2 * rr)
          let cx = curr.at(0) - sx1 * rr + sx2 * rr
          let cy = curr.at(1) - sy1 * rr + sy2 * rr

          let a0 = calc.atan2(pin.at(1) - cy, pin.at(0) - cx)
          let a1 = calc.atan2(pout.at(1) - cy, pout.at(0) - cx)
          let turn = sx1 * sy2 - sy1 * sx2
          let delta = a1 - a0
          if turn > 0 and delta < 0deg { delta += 360deg }
          if turn < 0 and delta > 0deg { delta -= 360deg }

          out.push(pin)
          for k in range(1, steps) {
            let a = a0 + delta * (k / steps)
            out.push((cx + rr * calc.cos(a), cy + rr * calc.sin(a)))
          }
          out.push(pout)
        }
      }
    }
    out.push(points.last())
    out
  }
}

#let route-arrow(
  p0,
  q0,
  out-side: "right",
  in-side: "left",
  auto-spacing: true,
  spacing: 0.45,
  mode: "hv",
  mode-shift: none,
  mode-shifts: none,
  label: none,
  label-side: "above",
  label-gap: 0.30,
  label-dx: 0.0,
  label-dy: 0.0,
) = {
  let dv-out = side-dir(out-side)
  let dv-in = side-dir(in-side)

  let p1 = if auto-spacing {
    (p0.at(0) + dv-out.at(0) * spacing, p0.at(1) + dv-out.at(1) * spacing)
  } else {
    p0
  }

  let q1 = if auto-spacing {
    (q0.at(0) + dv-in.at(0) * spacing, q0.at(1) + dv-in.at(1) * spacing)
  } else {
    q0
  }

  let raw-segs = mode.clusters().filter(s => s == "h" or s == "v")
  let segs = if raw-segs.len() == 0 {
    ("h", "v")
  } else {
    raw-segs
  }
  let n = segs.len()

  let dx = q1.at(0) - p1.at(0)
  let dy = q1.at(1) - p1.at(1)
  let sx = if dx >= 0 { 1 } else { -1 }
  let sy = if dy >= 0 { 1 } else { -1 }
  let adx = calc.abs(dx)
  let ady = calc.abs(dy)

  let normalize-segment-index(raw, n) = {
    if type(raw) != int {
      none
    } else if raw > 0 and raw <= n {
      raw
    } else if raw == 0 {
      n
    } else if raw < 0 {
      let idx = n + raw + 1
      if idx >= 1 and idx <= n { idx } else { none }
    } else {
      none
    }
  }

  let normalize-segment-length(raw) = {
    if raw == none {
      none
    } else if type(raw) == int or type(raw) == float {
      raw
    } else {
      none
    }
  }

  let mode-shifts-direct-indexed = {
    if mode-shifts == none or mode-shifts.len() < 2 {
      false
    } else {
      let has-int-index = type(mode-shifts.at(0, default: none)) == int
      let has-numeric-length = normalize-segment-length(mode-shifts.at(1, default: none)) != none
      has-int-index and has-numeric-length
    }
  }

  let mode-shifts-indexed-list = {
    if mode-shifts == none or mode-shifts.len() == 0 {
      false
    } else {
      let first = mode-shifts.at(0, default: none)
      let is-pair = type(first) == array and first.len() >= 2
      if not is-pair {
        false
      } else {
        let has-int-index = type(first.at(0, default: none)) == int
        let has-numeric-length = normalize-segment-length(first.at(1, default: none)) != none
        has-int-index and has-numeric-length
      }
    }
  }

  let mode-shifts-indexed = mode-shifts-direct-indexed or mode-shifts-indexed-list

  let indexed-mode-shift(i) = {
    if not mode-shifts-indexed {
      none
    } else if mode-shifts-direct-indexed {
      let idx = normalize-segment-index(mode-shifts.at(0), n)
      let val = normalize-segment-length(mode-shifts.at(1))
      if idx != none and idx == i { val } else { none }
    } else {
      let found = none
      for j in range(mode-shifts.len()) {
        let entry = mode-shifts.at(j)
        if type(entry) == array and entry.len() >= 2 {
          let idx = normalize-segment-index(entry.at(0), n)
          let val = normalize-segment-length(entry.at(1))
          if idx != none and idx == i and val != none {
            found = val
          }
        }
      }
      found
    }
  }

  let seg-override(i) = {
    if mode-shifts-indexed {
      indexed-mode-shift(i)
    } else if mode-shifts != none and i <= mode-shifts.len() {
      normalize-segment-length(mode-shifts.at(i - 1, default: none))
    } else if mode-shift != none and mode-shift.len() >= 2 {
      let idx = normalize-segment-index(mode-shift.at(0), n)
      let val = normalize-segment-length(mode-shift.at(1))
      if idx != none and idx == i { val } else { none }
    } else {
      none
    }
  }

  let h-known = 0.0
  let v-known = 0.0
  let h-unk = 0
  let v-unk = 0
  let h-last = 0
  let v-last = 0
  let h-last-overridden = false
  let v-last-overridden = false
  for i in range(1, n + 1) {
    let axis = segs.at(i - 1)
    let ov = seg-override(i)
    if axis == "h" {
      h-last = i
      h-last-overridden = ov != none
      if ov == none { h-unk += 1 } else { h-known += ov }
    } else {
      v-last = i
      v-last-overridden = ov != none
      if ov == none { v-unk += 1 } else { v-known += ov }
    }
  }

  let h-rem = adx - h-known
  let v-rem = ady - v-known
  let h-each = if h-unk > 0 { h-rem / h-unk } else { 0 }
  let v-each = if v-unk > 0 { v-rem / v-unk } else { 0 }
  let h-adjust = if h-unk == 0 and not h-last-overridden { h-rem } else { 0 }
  let v-adjust = if v-unk == 0 and not v-last-overridden { v-rem } else { 0 }

  let seg-lens = ()
  for i in range(1, n + 1) {
    let axis = segs.at(i - 1)
    let ov = seg-override(i)
    let l = if ov != none {
      ov
    } else if axis == "h" {
      h-each
    } else {
      v-each
    }

    if axis == "h" and i == h-last {
      l += h-adjust
    }
    if axis == "v" and i == v-last {
      l += v-adjust
    }
    seg-lens.push(l)
  }

  let core = (p1,)
  let cx = p1.at(0)
  let cy = p1.at(1)
  for i in range(0, n) {
    let axis = segs.at(i)
    let l = seg-lens.at(i)
    if axis == "h" {
      cx += sx * l
    } else {
      cy += sy * l
    }
    core.push((cx, cy))
  }

  if calc.abs(cx - q1.at(0)) > 0.001 {
    cx = q1.at(0)
    core.push((cx, cy))
  }
  if calc.abs(cy - q1.at(1)) > 0.001 {
    cy = q1.at(1)
    core.push((cx, cy))
  }
  if not same-point(core.last(), q1) {
    core.push(q1)
  }

  let points = ()
  points.push(p0)
  for pt in core {
    if not same-point(points.last(), pt) {
      points.push(pt)
    }
  }
  if not same-point(points.last(), q0) {
    points.push(q0)
  }

  let label-a = p1
  let label-b = q1
  let best = -1.0
  for i in range(0, core.len() - 1) {
    let a = core.at(i)
    let b = core.at(i + 1)
    let d = calc.abs(b.at(0) - a.at(0)) + calc.abs(b.at(1) - a.at(1))
    if d > best {
      best = d
      label-a = a
      label-b = b
    }
  }

  (
    p0: p0,
    p1: p1,
    m: if points.len() > 2 { points.at(1) } else { p1 },
    q1: q1,
    q0: q0,
    has-bend: points.len() > 3,
    points: points,
    label: label,
    label-a: label-a,
    label-b: label-b,
    label-side: label-side,
    label-gap: label-gap,
    label-dx: label-dx,
    label-dy: label-dy,
  )
}

#let route-options(
  out-side: "right",
  in-side: "left",
  auto-spacing: true,
  spacing: 0.45,
  mode: "hv",
  mode-shift: none,
  mode-shifts: none,
  corner-radius: none,
  label: none,
  label-side: "above",
  label-gap: 0.30,
  label-dx: 0.0,
  label-dy: 0.0,
) = (
  out-side: out-side,
  in-side: in-side,
  auto-spacing: auto-spacing,
  spacing: spacing,
  mode: mode,
  mode-shift: mode-shift,
  mode-shifts: mode-shifts,
  corner-radius: corner-radius,
  label: label,
  label-side: label-side,
  label-gap: label-gap,
  label-dx: label-dx,
  label-dy: label-dy,
)

#let build-arrow(
  from,
  to,
  p0,
  q0,
  opts,
  from-outer: false,
  from-outer-value: none,
  to-outer: false,
  to-outer-value: none,
) = {
  (
    ..route-arrow(
      p0,
      q0,
      out-side: opts.out-side,
      in-side: opts.in-side,
      auto-spacing: opts.auto-spacing,
      spacing: opts.spacing,
      mode: opts.mode,
      mode-shift: opts.mode-shift,
      mode-shifts: opts.mode-shifts,
      label: opts.label,
      label-side: opts.label-side,
      label-gap: opts.label-gap,
      label-dx: opts.label-dx,
      label-dy: opts.label-dy,
    ),
    from: from,
    to: to,
    out-side: opts.out-side,
    in-side: opts.in-side,
    from-outer: from-outer,
    from-outer-value: from-outer-value,
    to-outer: to-outer,
    to-outer-value: to-outer-value,
    auto-spacing: opts.auto-spacing,
    spacing: opts.spacing,
    mode: opts.mode,
    mode-shift: opts.mode-shift,
    mode-shifts: opts.mode-shifts,
    corner-radius: opts.corner-radius,
  )
}

#let make-arrow(
  from,
  to,
  out-side: "right",
  in-side: "left",
  from-outer: false,
  from-outer-value: none,
  to-outer: false,
  to-outer-value: none,
  auto-spacing: true,
  spacing: 0.45,
  mode: "hv",
  mode-shift: none,
  mode-shifts: none,
  corner-radius: none,
  radius: none,
  label: none,
  label-side: "above",
  label-gap: 0.30,
  label-dx: 0.0,
  label-dy: 0.0,
) = {
  let corner-radius = if corner-radius != none { corner-radius } else { radius }
  let opts = route-options(
    out-side: out-side,
    in-side: in-side,
    auto-spacing: auto-spacing,
    spacing: spacing,
    mode: mode,
    mode-shift: mode-shift,
    mode-shifts: mode-shifts,
    corner-radius: corner-radius,
    label: label,
    label-side: label-side,
    label-gap: label-gap,
    label-dx: label-dx,
    label-dy: label-dy,
  )
  let p0 = node-anchor(from, side: opts.out-side, outer: from-outer, outer-value: from-outer-value)
  let q0 = node-anchor(to, side: opts.in-side, outer: to-outer, outer-value: to-outer-value)

  build-arrow(
    from,
    to,
    p0,
    q0,
    opts,
    from-outer: from-outer,
    from-outer-value: from-outer-value,
    to-outer: to-outer,
    to-outer-value: to-outer-value,
  )
}

#let edge-label(a, b, txt, side: "above", gap: 0.22, dx: 0.0, dy: 0.0, size: 0.48em) = {
  let mx = (a.at(0) + b.at(0)) / 2 + dx
  let my = (a.at(1) + b.at(1)) / 2 + dy
  let horiz = calc.abs(a.at(1) - b.at(1)) < 0.001
  let ox = if horiz { 0 } else if side == "right" { gap } else { -gap }
  let oy = if horiz { if side == "below" { -gap } else { gap } } else { 0 }
  draw.content((mx + ox, my + oy), text(size: size, fill: rgb("#555555"))[#txt])
}

#let same-side-group(a, b, role: "in") = {
  if role == "in" {
    a.to == b.to and a.in-side == b.in-side and a.to-outer == b.to-outer and a.to-outer-value == b.to-outer-value
  } else {
    a.from == b.from and a.out-side == b.out-side and a.from-outer == b.from-outer and a.from-outer-value == b.from-outer-value
  }
}

#let side-rank(arrows, idx, role: "in", eps: 0.0001) = {
  let curr = arrows.at(idx)
  let side = if role == "in" { curr.in-side } else { curr.out-side }
  let axis = side-axis(side)
  let curr-v = if role == "in" {
    axis-value(curr.from, axis)
  } else {
    axis-value(curr.to, axis)
  }

  let n = 0
  let rank = 0
  for j in range(arrows.len()) {
    let other = arrows.at(j)
    if same-side-group(curr, other, role: role) {
      n += 1
      let ov = if role == "in" {
        axis-value(other.from, axis)
      } else {
        axis-value(other.to, axis)
      }

      if ov < curr-v - eps or (calc.abs(ov - curr-v) <= eps and j < idx) {
        rank += 1
      }
    }
  }
  (n, rank)
}

#let distribute-arrow(arr, arrows, idx) = {
  if not ("from" in arr and "to" in arr and "out-side" in arr and "in-side" in arr) {
    arr
  } else {
    let p0 = {
      let (n, rank) = side-rank(arrows, idx, role: "out")
      if n > 1 {
        let t = (rank + 1) / (n + 1)
        side-point(arr.from, arr.out-side, t, outer: arr.from-outer, outer-value: arr.from-outer-value)
      } else {
        arr.p0
      }
    }

    let q0 = {
      let (n, rank) = side-rank(arrows, idx, role: "in")
      if n > 1 {
        let t = (rank + 1) / (n + 1)
        side-point(arr.to, arr.in-side, t, outer: arr.to-outer, outer-value: arr.to-outer-value)
      } else {
        arr.q0
      }
    }

    if same-point(p0, arr.p0) and same-point(q0, arr.q0) {
      arr
    } else {
      let opts = route-options(
        out-side: arr.out-side,
        in-side: arr.in-side,
        auto-spacing: arr.auto-spacing,
        spacing: arr.spacing,
        mode: arr.mode,
        mode-shift: arr.mode-shift,
        mode-shifts: arr.mode-shifts,
        corner-radius: if "corner-radius" in arr { arr.corner-radius } else { none },
        label: arr.label,
        label-side: arr.label-side,
        label-gap: arr.label-gap,
        label-dx: arr.label-dx,
        label-dy: arr.label-dy,
      )
      build-arrow(
        arr.from,
        arr.to,
        p0,
        q0,
        opts,
        from-outer: arr.from-outer,
        from-outer-value: arr.from-outer-value,
        to-outer: arr.to-outer,
        to-outer-value: arr.to-outer-value,
      )
    }
  }
}

#let draw-arrow-shape(arr) = {
  import draw: *

  let radius = if "corner-radius" in arr { arr.corner-radius } else { none }
  let points = if "points" in arr and arr.points.len() >= 2 {
    rounded-points(arr.points, radius)
  } else {
    rounded-points((arr.p0, arr.q0), radius)
  }

  line(..points,
    mark: (end: ">"),
    stroke: (paint: black, thickness: 0.75pt),
  )

  if arr.label != none {
    let a = if "label-a" in arr {
      arr.label-a
    } else {
      arr.p1
    }
    let b = if "label-b" in arr {
      arr.label-b
    } else {
      arr.q1
    }

    edge-label(
      a,
      b,
      arr.label,
      side: arr.label-side,
      gap: arr.label-gap,
      dx: arr.label-dx,
      dy: arr.label-dy,
    )
  }
}

#let draw-arrow(arr) = {
  draw-arrow-shape(arr)
}

#let draw-arrows(arrows, auto-distribute: true) = {
  for i in range(arrows.len()) {
    let base = arrows.at(i)
    let arr = if auto-distribute {
      distribute-arrow(base, arrows, i)
    } else {
      base
    }
    draw-arrow-shape(arr)
  }
}
