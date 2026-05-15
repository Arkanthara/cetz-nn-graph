# Publishing Guide

This package targets the Typst Universe `preview` namespace.

## 1. Pre-submit checks

Run these checks before preparing a submission:

```sh
bash scripts/render-examples.sh
bash scripts/render-tests.sh
typst compile --package-path .typst/packages --root . docs/guide.typ /tmp/guide.pdf
bash scripts/prepare-package.sh
```

The prepared submission files will be in `dist/package`.

## 2. Sparse checkout (recommended)

For the `typst/packages` fork, use sparse checkout to reduce clone size:

```sh
git clone --depth 1 --no-checkout --filter="tree:0" git@github.com:{your-username}/packages
cd packages
git sparse-checkout init
git sparse-checkout set packages/preview/{your-package-name}
git remote add upstream git@github.com:typst/packages
git config remote.upstream.partialclonefilter tree:0
git checkout main
```

## 3. Copy files into typst/packages

Create the target directory and copy files:

```sh
mkdir -p packages/preview/neural-viz/0.2.0
cp -R /path/to/neural-viz/dist/package/. packages/preview/neural-viz/0.2.0/
```

## 4. Commit/exclude model used here

`dist/package` includes:

- Required runtime files: `typst.toml`, `lib.typ`, `src/`, `README.md`, `LICENSE`
- Documentation/support files referenced by docs and README: `docs/`, `assets/`

The manifest excludes development fixtures (`examples`, `scripts`, `tests`,
`.github`, `.typst`, and `dist`). Documentation stays in the prepared package.

## 5. Final reminders

- Do not use git submodules inside the submitted package directory.
- Keep README import versions aligned with `typst.toml` version.
- For a new release, update `typst.toml` version and README import snippets together.
