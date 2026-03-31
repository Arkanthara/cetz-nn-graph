#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
out_dir="$root/tests/output"

mkdir -p "$out_dir"
typst compile --root "$root" "$root/tests/all-tests.typ" "$out_dir/tests.pdf"
