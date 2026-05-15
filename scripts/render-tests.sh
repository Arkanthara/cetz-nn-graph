#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
out_dir="$root/tests/output"
source "$root/scripts/typst-bin.sh"
typst_bin="$(resolve_typst_bin)"

mkdir -p "$out_dir"
"$root/scripts/bootstrap-fletcher.sh"
"$typst_bin" compile \
  --package-path "$(typst_path "$root/.typst/packages" "$typst_bin")" \
  --root "$(typst_path "$root" "$typst_bin")" \
  "$(typst_path "$root/tests/all-tests.typ" "$typst_bin")" \
  "$(typst_path "$out_dir/tests.pdf" "$typst_bin")"
