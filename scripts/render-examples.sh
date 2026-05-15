#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
out_dir="$root/docs/images"
tmp="$root/.tmp-render-example.typ"
source "$root/scripts/typst-bin.sh"
typst_bin="$(resolve_typst_bin)"

mkdir -p "$out_dir"
trap 'rm -f "$tmp"' EXIT
shopt -s nullglob
for file in "$root/examples/"*.typ; do
  name="$(basename "$file" .typ)"
  cat > "$tmp" <<EOF
#set page(width: auto, height: auto, margin: 0pt)
#include "examples/$name.typ"
EOF
  "$typst_bin" compile \
    --package-path "$(typst_path "$root/.typst/packages" "$typst_bin")" \
    --root "$(typst_path "$root" "$typst_bin")" \
    --format svg \
    "$(typst_path "$tmp" "$typst_bin")" \
    "$(typst_path "$out_dir/$name.svg" "$typst_bin")"
done
