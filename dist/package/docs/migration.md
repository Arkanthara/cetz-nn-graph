# Migration From the CeTZ-Based Version

`neural-viz` has been rewritten around Fletcher. The old public names still
exist as shims, but the preferred model is now:

1. Give every node a stable id.
2. Describe ML concepts with semantic constructors.
3. Connect ids with `ml-edge`.
4. Let `ml-diagram` apply layout and render through Fletcher.

## Mapping

| Old | New |
| --- | --- |
| `make-dataset` | `dataset` or `batch` |
| `make-image-node` | `image-node` |
| `make-image-dataset` | `image-dataset` |
| `make-latent-space` | `tensor(..., stack: 1)` or `embedding` |
| `make-trapezoid(mode: "encoder")` | `encoder` |
| `make-trapezoid(mode: "decoder")` | `decoder` |
| `make-box` | `module`, `operation`, `layer`, `transformer` |
| `make-arrow` | `ml-edge` |
| `draw-graph` | `ml-diagram` |

## Example

```typ
#let nodes = (
  dataset("train", title: [Training set]),
  encoder("enc", title: [Encoder]),
  tensor("latent", title: [Latent], stack: 1),
  decoder("dec", title: [Decoder]),
)

#let edges = (
  ml-edge("train", "enc", label: [input]),
  ml-edge("enc", "latent"),
  ml-edge("latent", "dec"),
)

#ml-diagram(nodes, edges: edges, layout: "pipeline")
```

## What Changed

- Manual edge routing code was removed.
- Fletcher now owns snapping, labels, marks, groups, and anchors.
- `group` uses Fletcher `enclose`.
- Position helpers return Fletcher coordinates.
- Layout is deterministic and separate from rendering.
