#import "src/core/utils.typ": neural-viz-version, fletcher-version, as-node-id, slug, merge, to-length, to-size, ensure-array
#import "src/core/position.typ": node-ref, anchor-ref, right-of, left-of, above, below, offset-pos, explicit-pos, is-auto-pos
#import "src/core/spec.typ": ml-node, ml-edge, node-id, node-pos, with-pos, with-meta
#import "src/layout/flow.typ": layout-pipeline, layout-dag, layout-grid, apply-layout
#import "src/ml/nodes.typ": dataset, batch, tensor, vector, embedding, image-node, image-dataset, module, operation, layer, encoder, decoder, attention, transformer, io-node, decision, group, text-node, arrow-node, gate-node, compare-node
#import "src/render/fletcher.typ": ml-diagram, draw-graph, draw-node, draw-nodes, draw-arrow, draw-arrows, spread-arrows, graph-canvas, shapes
#import "src/compat.typ": make-dataset, make-image-node, make-image-dataset, make-latent-space, make-rectangle, make-trapezoid, make-box, make-square, make-circle, make-text, make-arrow, set-arrow-defaults, set-dataset-defaults, set-image-node-defaults, set-image-dataset-defaults, set-latent-space-defaults, set-rectangle-defaults, set-trapezoid-defaults, set-box-defaults, set-square-defaults, set-circle-defaults, set-text-defaults, chars-cap, node-size, node-edge, node-anchor, auto-pos-right, side-dir, edge-label, draw-node-emoji
