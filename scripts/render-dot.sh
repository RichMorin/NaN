#!/usr/bin/env bash
set -euo pipefail

DOT_FILE="${1:-docs/diagrams/dot/example.dot}"

if [[ ! -f "$DOT_FILE" ]]; then
  echo "DOT file not found: $DOT_FILE" >&2
  exit 1
fi

# Compute output SVG path under _site/gen/docs/diagrams/svg
if [[ "$DOT_FILE" != docs/diagrams/dot/* ]]; then
  echo "DOT file must be under docs/diagrams/dot/" >&2
  exit 1
fi

REL="${DOT_FILE#docs/diagrams/dot/}"
OUT="_site/gen/docs/diagrams/svg/${REL%.dot}.svg"

mkdir -p "$(dirname "$OUT")"
if grep -q 'pos="[^"]\+!"' "$DOT_FILE"; then
  neato -n2 -Tsvg "$DOT_FILE" -o "$OUT"
else
  dot -Tsvg "$DOT_FILE" -o "$OUT"
fi

# Clear quarantine if present
xattr -d com.apple.quarantine "$OUT" 2>/dev/null || true

# Open in Safari for reliable SVG viewing
open -a Safari "file:///$(pwd)/$OUT"

printf "Rendered %s -> %s\n" "$DOT_FILE" "$OUT"
