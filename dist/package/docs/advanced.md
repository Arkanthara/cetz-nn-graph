# Advanced Usage

## Mixed Positioning

Layouts only place nodes whose `pos` is `auto`. Explicit positions and
Fletcher-relative coordinates are preserved.

```typ
#let nodes = (
  dataset("input", title: [Input], pos: (0, 0)),
  encoder("enc", title: [Encoder]),
  attention("attn", title: [Attention], pos: right-of("enc", dy: -0.75)),
)
```

## Custom Layouts

Pass a function to `layout`.

```typ
#let my-layout(nodes, edges: ()) = layout-grid(nodes, columns: 4)
#ml-diagram(nodes, edges: edges, layout: my-layout)
```

## Fletcher Integration

The wrapper keeps Fletcher concepts visible:

- `from-side` and `to-side` become Fletcher anchor labels.
- `bend`, `corner`, `corner-radius`, `crossing`, labels, marks, and strokes are
  forwarded to `fletcher.edge`.
- `group` forwards `enclose` to `fletcher.node`.
- `ml-diagram` forwards diagram options such as `spacing`, `cell-size`, `axes`,
  and `debug`.

## Performance Notes

Layouts operate over immutable node specs and edge specs. `layout-dag` performs
a bounded rank relaxation over `nodes.len()` passes, which is predictable for
large DAGs and avoids recursive graph traversal inside rendering. Fletcher then
handles the final diagram measurement and routing.
