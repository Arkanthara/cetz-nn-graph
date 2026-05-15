#let neural-viz-version = "0.2.0"
#let fletcher-version = "0.5.9"
#let default-unit = 0.72cm

#let ensure-array(value) = if type(value) == array { value } else { (value,) }

#let merge(base, override) = {
  let out = base
  for (key, value) in override.pairs() {
    if value != auto {
      out.insert(key, value)
    }
  }
  out
}

#let slug(value, fallback: "node") = {
  let raw = if value == none {
    fallback
  } else if type(value) == str {
    value
  } else if type(value) == label {
    str(value)
  } else {
    repr(value)
  }

  let out = ""
  let prev-dash = false
  for ch in raw.clusters() {
    let ok = (
      (ch >= "a" and ch <= "z") or
      (ch >= "A" and ch <= "Z") or
      (ch >= "0" and ch <= "9")
    )
    if ok {
      out += ch
      prev-dash = false
    } else if not prev-dash and out != "" {
      out += "-"
      prev-dash = true
    }
  }
  while out.ends-with("-") {
    out = out.slice(0, -1)
  }
  if out == "" { fallback } else { out }
}

#let as-node-id(value, fallback: "node") = {
  if value == none or value == auto {
    fallback
  } else if type(value) == str {
    slug(value, fallback: fallback)
  } else if type(value) == label {
    slug(str(value), fallback: fallback)
  } else {
    slug(repr(value), fallback: fallback)
  }
}

#let to-length(value, unit: default-unit) = {
  if value == auto or value == none {
    value
  } else if type(value) == length {
    value
  } else if type(value) == int or type(value) == float {
    value * unit
  } else {
    value
  }
}

#let to-size(size, width: auto, height: auto, unit: default-unit, default: (auto, auto)) = {
  let pair = if size == auto or size == none {
    default
  } else if type(size) == array {
    size
  } else {
    (size, size)
  }
  let w = if width == auto or width == none { pair.at(0) } else { width }
  let h = if height == auto or height == none { pair.at(1) } else { height }
  (to-length(w, unit: unit), to-length(h, unit: unit))
}
