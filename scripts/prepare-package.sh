#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
dist="$root/dist/package"

rm -rf "$root/dist"
mkdir -p "$dist"

# Required package files (must be committed and included).
cp "$root/typst.toml" "$dist/"
cp "$root/lib.typ" "$dist/"
cp "$root/README.md" "$dist/"
cp "$root/LICENSE" "$dist/"
cp -R "$root/src" "$dist/"

# Documentation/support files used by README and manual examples.
# These are intentionally committed for Typst Universe display, but excluded
# from the downloaded package archive via typst.toml `exclude` patterns.
if [[ -d "$root/docs" ]]; then
	cp -R "$root/docs" "$dist/"
fi

if [[ -d "$root/assets" ]]; then
	cp -R "$root/assets" "$dist/"
fi
