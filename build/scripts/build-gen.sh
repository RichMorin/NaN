#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DOCS="$ROOT/docs"
GEN_ROOT="$ROOT/_site/gen"
GEN_DOCS="$GEN_ROOT/docs"
GEN_SVG="$GEN_DOCS/diagrams/svg"
MACROS="$SRC_DOCS/_data/md_macros.yml"

mkdir -p "$GEN_DOCS" "$GEN_SVG"

# Sync docs -> gen/docs (excluding generated SVG in source tree)
rsync -a --delete \
  --exclude 'diagrams/svg/' \
  "$SRC_DOCS/" "$GEN_DOCS/"

# Expand macros in Markdown
while IFS= read -r -d '' file; do
  rel="${file#$SRC_DOCS/}"
  out="$GEN_DOCS/$rel"
  python3 "$ROOT/scripts/preprocess-md.py" --macros "$MACROS" --in "$file" --out "$out"
done < <(find "$SRC_DOCS" -name '*.md' -print0)

# Render DOT -> gen/docs/diagrams/svg
if [[ -d "$SRC_DOCS/diagrams/dot" ]]; then
  while IFS= read -r -d '' dot_file; do
    rel="${dot_file#$SRC_DOCS/diagrams/dot/}"
    out="$GEN_SVG/${rel%.dot}.svg"
    mkdir -p "$(dirname "$out")"
    if grep -q 'pos="[^"]\+!"' "$dot_file"; then
      neato -n2 -Tsvg "$dot_file" -o "$out"
    else
      dot -Tsvg "$dot_file" -o "$out"
    fi
    xattr -d com.apple.quarantine "$out" 2>/dev/null || true
  done < <(find "$SRC_DOCS/diagrams/dot" -name '*.dot' -print0)
fi

# Patch SVGs listed in docs/_data/svg_patches.yml
if [[ -f "$SRC_DOCS/_data/svg_patches.yml" ]]; then
  python3 "$ROOT/scripts/patch-svg-list.py" \
    --patches "$SRC_DOCS/_data/svg_patches.yml" \
    --svg-dir "$GEN_SVG" \
    --script "$ROOT/scripts/patch-example-svg.py"
fi

printf "Generated docs to %s\n" "$GEN_DOCS"
