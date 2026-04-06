#import "@preview/cetz:0.4.2": canvas, draw

/// Create a CeTZ canvas with neural-viz defaults.
///
/// `length` sets the base unit used by node sizes and spacing.
#let graph-canvas(body, length: 0.72cm) = {
  canvas(length: length, {
    import draw: *
    body
  })
}
