#import "../internal/text.typ": truncate-title
#import "../internal/geometry.typ": resolve-node-center

#let resolve-node-size(image-size, image-width, image-height, default-size) = {
  let base = if image-size == none { default-size } else { image-size }
  let w = if image-width == none { base.at(0) } else { image-width }
  let h = if image-height == none { base.at(1) } else { image-height }
  (w, h)
}

#let resolve-fit-geometry(target-w, target-h, content-aspect, fit: "cover") = {
  let safe-aspect = if content-aspect > 0 { content-aspect } else { target-w / target-h }
  let target-aspect = target-w / target-h

  if fit == "stretch" {
    (target-w, target-h, true)
  } else if fit == "contain" {
    if safe-aspect > target-aspect {
      (target-w, target-w / safe-aspect, false)
    } else {
      (target-h * safe-aspect, target-h, false)
    }
  } else {
    if safe-aspect > target-aspect {
      (target-h * safe-aspect, target-h, true)
    } else {
      (target-w, target-w / safe-aspect, true)
    }
  }
}

#let fit-image-content(content, target-w, target-h, fit: "cover", shift-x: 0.0, shift-y: 0.0) = context {
  let m = measure(content)
  let cw = if m.width > 0pt { m.width } else { target-w }
  let ch = if m.height > 0pt { m.height } else { target-h }
  let content-aspect = cw / ch
  let (render-w, render-h, clip-image) = resolve-fit-geometry(target-w, target-h, content-aspect, fit: fit)
  let kx = render-w / cw
  let ky = render-h / ch

  let shift-x = calc.clamp(shift-x, -1.0, 1.0)
  let shift-y = calc.clamp(shift-y, -1.0, 1.0)
  let dx = (render-w - target-w) / 2 * shift-x
  let dy = (render-h - target-h) / 2 * shift-y

  box(width: target-w, height: target-h, inset: 0pt, clip: clip-image)[
    #place(center, dx: dx, dy: dy)[#scale(x: kx * 100%, y: ky * 100%)[#content]]
  ]
}

#let fit-image-source(src, target-w, target-h, fit: "cover", shift-x: 0.0, shift-y: 0.0) = context {
  let probe = measure(image(src, width: 100pt))
  let source-aspect = if probe.width > 0pt and probe.height > 0pt {
    probe.width / probe.height
  } else {
    target-w / target-h
  }

  let (render-w, render-h, clip-image) = resolve-fit-geometry(target-w, target-h, source-aspect, fit: fit)
  let shift-x = calc.clamp(shift-x, -1.0, 1.0)
  let shift-y = calc.clamp(shift-y, -1.0, 1.0)
  let dx = (render-w - target-w) / 2 * shift-x
  let dy = (render-h - target-h) / 2 * shift-y

  box(width: target-w, height: target-h, inset: 0pt, clip: clip-image)[
    #place(center, dx: dx, dy: dy)[#image(src, width: render-w, height: render-h, fit: "stretch")]
  ]
}

#let resolve-image(src, img, w, h, unit: 0.72cm, fit: "cover", pad: 0.1, shift-x: 0.0, shift-y: 0.0) = {
  let iw = calc.max(0.01, w - 2 * pad)
  let ih = calc.max(0.01, h - 2 * pad)
  let target-w = iw * unit
  let target-h = ih * unit

  if src != none {
    fit-image-source(src, target-w, target-h, fit: fit, shift-x: shift-x, shift-y: shift-y)
  } else if img != none {
    fit-image-content(img, target-w, target-h, fit: fit, shift-x: shift-x, shift-y: shift-y)
  } else {
    none
  }
}

/// Build a single image node.
///
/// Example:
/// ```typ
/// let img = make-image-node("Input", src: "/assets/test.jpg", pos: (1.0, 0.0))
/// ```
#let make-image-node(
  title,
  subtitle: none,
  legend: none,
  legend-position: "below",
  src: none,
  img: none,
  image-size: none,
  image-width: none,
  image-height: none,
  image-fit: "cover",
  image-pad: 0.1,
  image-shift-x: 0.0,
  image-shift-y: 0.0,
  unit: 0.72cm,
  title-truncate: false,
  max-title-chars: 18,
  title-position: "below",
  pos: none,
  after: none,
  gap: 1.0,
  y: none,
  color: rgb("#ffffff"),
  border: true,
  title-size: 0.58em,
  subtitle-size: 0.50em,
  legend-size: 0.48em,
  wrap-lines: 2,
) = {
  let (w, h) = resolve-node-size(image-size, image-width, image-height, (2.2, 2.2))
  let (cx, cy) = resolve-node-center(pos, after, w, gap: gap, y: y, default-x: 1.0)

  (
    kind: "image",
    cx: cx,
    cy: cy,
    w: w,
    h: h,
    color: color,
    border: border,
    title: truncate-title(title, enabled: title-truncate, max-chars: max-title-chars),
    subtitle: subtitle,
    legend: legend,
    legend-position: legend-position,
    title-size: title-size,
    subtitle-size: subtitle-size,
    legend-size: legend-size,
    wrap-lines: wrap-lines,
    title-position: title-position,
    image: resolve-image(
      src,
      img,
      w,
      h,
      unit: unit,
      fit: image-fit,
      pad: image-pad,
      shift-x: image-shift-x,
      shift-y: image-shift-y,
    ),
  )
}

/// Build a stacked image dataset node.
///
/// Example:
/// ```typ
/// let ds = make-image-dataset("Train", src: "/assets/test.jpg", images: 4)
/// ```
#let make-image-dataset(
  title,
  subtitle: none,
  legend: none,
  legend-position: "below",
  src: none,
  img: none,
  images: 3,
  image-size: none,
  image-width: none,
  image-height: none,
  image-spacing: 0.22,
  image-fit: "cover",
  image-pad: 0.0,
  image-shift-x: 0.0,
  image-shift-y: 0.0,
  unit: 0.72cm,
  title-truncate: false,
  max-title-chars: 18,
  title-position: "below",
  pos: none,
  after: none,
  gap: 1.0,
  y: none,
  color: rgb("#a8c8e8"),
  border: true,
  title-size: 0.58em,
  subtitle-size: 0.50em,
  legend-size: 0.48em,
  wrap-lines: 2,
) = {
  let (w, h) = resolve-node-size(image-size, image-width, image-height, (1.9, 2.3))
  let (cx, cy) = resolve-node-center(pos, after, w, gap: gap, y: y, default-x: 1.0)

  (
    kind: "stack",
    cx: cx,
    cy: cy,
    w: w,
    h: h,
    n: images,
    shift: image-spacing,
    color: color,
    border: border,
    title: truncate-title(title, enabled: title-truncate, max-chars: max-title-chars),
    subtitle: subtitle,
    legend: legend,
    legend-position: legend-position,
    title-size: title-size,
    subtitle-size: subtitle-size,
    legend-size: legend-size,
    wrap-lines: wrap-lines,
    title-position: title-position,
    image: resolve-image(
      src,
      img,
      w,
      h,
      unit: unit,
      fit: image-fit,
      pad: image-pad,
      shift-x: image-shift-x,
      shift-y: image-shift-y,
    ),
  )
}
