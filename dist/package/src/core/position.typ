#import "utils.typ": as-node-id

#let is-auto-pos(pos) = pos == auto or pos == none

#let node-ref(value) = {
  if type(value) == label {
    value
  } else if type(value) == dictionary and "id" in value {
    label(value.id)
  } else if type(value) == str {
    label(as-node-id(value))
  } else {
    value
  }
}

#let _anchor-name(side) = {
  if side == "left" or side == "west" {
    "west"
  } else if side == "right" or side == "east" {
    "east"
  } else if side == "top" or side == "north" or side == "above" {
    "north"
  } else if side == "bottom" or side == "south" or side == "below" {
    "south"
  } else {
    "center"
  }
}

#let anchor-ref(value, side: none) = {
  if side == none or side == "center" {
    node-ref(value)
  } else if type(value) == dictionary and "id" in value {
    label(value.id + "." + _anchor-name(side))
  } else if type(value) == str {
    label(as-node-id(value) + "." + _anchor-name(side))
  } else if type(value) == label {
    label(str(value) + "." + _anchor-name(side))
  } else {
    value
  }
}

#let offset-pos(base, by: (0, 0)) = {
  if base == auto or base == none {
    (rel: by)
  } else if type(base) == array {
    (base.at(0) + by.at(0), base.at(1) + by.at(1))
  } else {
    (rel: by, to: node-ref(base))
  }
}

#let explicit-pos(x, y: 0) = (x, y)
#let right-of(ref, by: 1, dy: 0) = (rel: (by, dy), to: node-ref(ref))
#let left-of(ref, by: 1, dy: 0) = (rel: (-by, dy), to: node-ref(ref))
#let above(ref, by: 1, dx: 0) = (rel: (dx, -by), to: node-ref(ref))
#let below(ref, by: 1, dx: 0) = (rel: (dx, by), to: node-ref(ref))
