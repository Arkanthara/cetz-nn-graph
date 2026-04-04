#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
out_dir="$root/docs/images"
tmp="$root/.tmp-render-example.typ"

mkdir -p "$out_dir"
trap 'rm -f "$tmp"' EXIT

shopt -s nullglob
for file in "$root/examples/"*.typ; do
  name="$(basename "$file" .typ)"
  cat > "$tmp" <<EOF
#set page(width: auto, height: auto, margin: 0pt)
#include "examples/$name.typ"
EOF
  typst compile --root "$root" --format svg "$tmp" "$out_dir/$name.svg"
done
