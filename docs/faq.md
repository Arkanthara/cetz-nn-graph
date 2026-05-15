# FAQ

## Is this still based on CeTZ?

The public library is Fletcher-first. Fletcher itself uses CeTZ internally, but
`neural-viz` no longer exposes or reimplements CeTZ drawing logic.

## Can I still use the old API?

Yes. Compatibility functions are available, but new diagrams should use stable
ids and the semantic constructors.

## How do I force a node position?

Set `pos`.

```typ
#encoder("enc", title: [Encoder], pos: (2, 0))
```

## How do I position relative to another node?

Use helpers such as `right-of("enc")`, `below("loss")`, or Fletcher coordinate
dictionaries directly.

## How do I group modules?

Use `group("name", ("child-a", "child-b"), title: [Group title])`.
