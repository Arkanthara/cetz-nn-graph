#import "@preview/cetz:0.4.2": draw
#import "../internal/text.typ": fit-lines
#import "../internal/geometry.typ": chars-cap, node-size, node-edge

/// Draw one node returned by any `make-*` constructor.
#let draw-node(node) = {
  import draw: *

  let (nw, nh) = node-size(node)
  let max-chars = chars-cap(nw)
  let t = fit-lines(node.title, max-chars: max-chars, max-lines: node.wrap-lines)
  let s = fit-lines(node.subtitle, max-chars: max-chars, max-lines: node.wrap-lines)
  let g = fit-lines(node.legend, max-chars: chars-cap(nw + 0.6), max-lines: node.wrap-lines)

  let title-pos = if "title-position" in node { node.title-position } else { "inside" }
  let title-italic = node.kind == "trapezoid" or node.kind == "box"
  let title-body = if title-italic { [*#t*] } else { [#t] }

  let draw-inner-text(x, y) = {
    if node.subtitle == none {
      content((x, y), align(center)[#text(size: node.title-size)[#title-body]])
    } else {
      content((x, y + 0.26), align(center)[#text(size: node.title-size)[#title-body]])
      content((x, y - 0.36), align(center)[#text(size: node.subtitle-size, fill: rgb("#333333"))[#s]])
    }
  }

  let draw-title-block(x, y) = {
    if title-pos == "below" {
      content((x, y - nh / 2 - 0.55), align(center)[#text(size: node.title-size)[#title-body]])
      if node.subtitle != none {
        content((x, y - nh / 2 - 0.95), align(center)[#text(size: node.subtitle-size, fill: rgb("#333333"))[#s]])
      }
    } else if title-pos == "above" {
      content((x, y + nh / 2 + 0.55), align(center)[#text(size: node.title-size)[#title-body]])
      if node.subtitle != none {
        content((x, y + nh / 2 + 0.95), align(center)[#text(size: node.subtitle-size, fill: rgb("#333333"))[#s]])
      }
    } else {
      draw-inner-text(x, y)
    }
  }

  let draw-legend(x, y) = {
    if node.legend != none {
      let y-leg = if node.kind == "stack" {
        if node.legend-position == "top" {
          node-edge(node, side: "top", outer: true) + 0.55
        } else {
          node-edge(node, side: "bottom", outer: true) - 0.55
        }
      } else if node.legend-position == "top" {
        y + nh / 2 + 0.55
      } else {
        y - nh / 2 - 0.55
      }
      content((x, y-leg), align(center)[#text(size: node.legend-size, fill: rgb("#555555"))[#g]])
    }
  }

  let draw-image(x, y) = {
    if "image" in node and node.image != none {
      content((x, y), align(center)[#node.image])
    }
  }

  if node.kind == "stack" {
    let stroke-style = if "border" in node and node.border == false {
      none
    } else {
      (paint: black, thickness: 0.5pt)
    }
    for i in range(node.n) {
      let j = node.n - 1 - i
      let off = j * node.shift
      let x = node.cx + off
      let y = node.cy + off
      rect(
        (x - node.w / 2, y - node.h / 2),
        (x + node.w / 2, y + node.h / 2),
        fill: node.color,
        stroke: stroke-style,
      )

      // For image datasets, draw the same fitted image on each stack layer.
      draw-image(x, y)
    }

    draw-title-block(node.cx, node.cy)
    draw-legend(node.cx, node.cy)
  } else if node.kind == "image" {
    let stroke-style = if "border" in node and node.border == false {
      none
    } else {
      (paint: black, thickness: 0.65pt)
    }
    rect(
      (node.cx - node.w / 2, node.cy - node.h / 2),
      (node.cx + node.w / 2, node.cy + node.h / 2),
      fill: node.color,
      stroke: stroke-style,
    )
    draw-image(node.cx, node.cy)
    draw-title-block(node.cx, node.cy)
    draw-legend(node.cx, node.cy)
  } else if node.kind == "text" {
    draw-title-block(node.cx, node.cy)
    draw-legend(node.cx, node.cy)
  } else if node.kind == "circle" {
    circle(
      (node.cx, node.cy),
      radius: node.w / 2,
      fill: node.color,
      stroke: (paint: black, thickness: 0.65pt),
    )
    draw-title-block(node.cx, node.cy)
    draw-legend(node.cx, node.cy)
  } else if node.kind == "trapezoid" {
    let lx = node.cx - node.w / 2
    let rx = node.cx + node.w / 2
    line(
      (lx, node.cy - node.h-left), (rx, node.cy - node.h-right),
      (rx, node.cy + node.h-right), (lx, node.cy + node.h-left),
      close: true,
      fill: node.color,
      stroke: (paint: black, thickness: 0.65pt),
    )
    draw-title-block(node.cx, node.cy)
    draw-legend(node.cx, node.cy)
  } else {
    rect(
      (node.cx - node.w / 2, node.cy - node.h / 2),
      (node.cx + node.w / 2, node.cy + node.h / 2),
      fill: node.color,
      stroke: (paint: black, thickness: 0.65pt),
    )
    draw-title-block(node.cx, node.cy)
    draw-legend(node.cx, node.cy)
  }
}

/// Draw a tuple of nodes.
///
/// Example:
/// ```typ
/// let nodes = (a, b, c)
/// draw-nodes(nodes)
/// ```
#let draw-nodes(nodes) = {
  for i in range(nodes.len()) {
    draw-node(nodes.at(i))
  }
}
