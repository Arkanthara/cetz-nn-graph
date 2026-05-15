#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
package_path="$root/.typst/packages"
target="$package_path/preview/fletcher/0.5.9"

if [[ -f "$target/typst.toml" ]]; then
  exit 0
fi

mkdir -p "$(dirname "$target")"
git clone --depth 1 https://github.com/Jollywatt/typst-fletcher.git "$target"

if ! grep -q 'version = "0.5.9"' "$target/typst.toml"; then
  echo "Expected Fletcher 0.5.9 from upstream main, but typst.toml differs." >&2
  exit 1
fi
