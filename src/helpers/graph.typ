#import "../draw/nodes.typ": draw-nodes
#import "../draw/arrows.typ": draw-arrows

/// Draw a full graph from node and arrow tuples.
///
/// Example:
/// ```typ
/// let nodes = (input, hidden, output)
/// let arrows = (
///   make-arrow(input, hidden),
///   make-arrow(hidden, output),
/// )
/// draw-graph(nodes: nodes, arrows: arrows)
/// ```
#let draw-graph(nodes: (), arrows: (), auto-distribute: true) = {
  draw-nodes(nodes)
  draw-arrows(arrows, auto-distribute: auto-distribute)
}
