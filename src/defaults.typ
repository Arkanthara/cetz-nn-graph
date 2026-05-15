#import "draw/arrows.typ": make-arrow
#import "nodes/dataset.typ": make-dataset
#import "nodes/image.typ": make-image-node, make-image-dataset
#import "nodes/latent.typ": make-latent-space, make-rectangle
#import "nodes/trapezoid.typ": make-trapezoid
#import "nodes/box.typ": make-box
#import "nodes/square.typ": make-square
#import "nodes/circle.typ": make-circle
#import "nodes/text.typ": make-text

/// Return `make-arrow` with default options pre-applied.
#let set-arrow-defaults(options: ()) = make-arrow.with(..options)
/// Return `make-dataset` with default options pre-applied.
#let set-dataset-defaults(options: ()) = make-dataset.with(..options)
/// Return `make-image-node` with default options pre-applied.
#let set-image-node-defaults(options: ()) = make-image-node.with(..options)
/// Return `make-image-dataset` with default options pre-applied.
#let set-image-dataset-defaults(options: ()) = make-image-dataset.with(..options)
/// Return `make-latent-space` with default options pre-applied.
#let set-latent-space-defaults(options: ()) = make-latent-space.with(..options)
/// Return `make-rectangle` with default options pre-applied.
#let set-rectangle-defaults(options: ()) = make-rectangle.with(..options)
/// Return `make-trapezoid` with default options pre-applied.
#let set-trapezoid-defaults(options: ()) = make-trapezoid.with(..options)
/// Return `make-box` with default options pre-applied.
#let set-box-defaults(options: ()) = make-box.with(..options)
/// Return `make-square` with default options pre-applied.
#let set-square-defaults(options: ()) = make-square.with(..options)
/// Return `make-circle` with default options pre-applied.
#let set-circle-defaults(options: ()) = make-circle.with(..options)
/// Return `make-text` with default options pre-applied.
#let set-text-defaults(options: ()) = make-text.with(..options)
