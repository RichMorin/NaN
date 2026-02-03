#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOT_DIR="$ROOT/docs/diagrams/dot"
SVG_DIR="$ROOT/_site/gen/docs/diagrams/svg"

if [[ ! -d "$DOT_DIR" ]]; then
  echo "DOT directory not found: $DOT_DIR" >&2
  exit 1
fi

render_one() {
  local dot_file="$1"
  local rel="${dot_file#$DOT_DIR/}"
  local out="$SVG_DIR/${rel%.dot}.svg"
  mkdir -p "$(dirname "$out")"
  if grep -q 'pos="[^"]\+!"' "$dot_file"; then
    neato -n2 -Tsvg "$dot_file" -o "$out"
  else
    dot -Tsvg "$dot_file" -o "$out"
  fi
  xattr -d com.apple.quarantine "$out" 2>/dev/null || true
  echo "Rendered: $dot_file -> $out"
}

render_all() {
  local files=()
  while IFS= read -r -d '' f; do
    files+=("$f")
  done < <(find "$DOT_DIR" -name '*.dot' -print0)

  if [[ ${#files[@]} -eq 0 ]]; then
    echo "No .dot files found in $DOT_DIR" >&2
    return 0
  fi

  for f in "${files[@]}"; do
    render_one "$f"
  done
}

if [[ "${1:-}" == "--once" ]]; then
  render_all
  exit 0
fi

if ! command -v fswatch >/dev/null 2>&1; then
  echo "fswatch not found. Install it with: brew install fswatch" >&2
  exit 1
fi

# Initial render
render_all

echo "Watching $DOT_DIR for changes..."
fswatch -0 "$DOT_DIR" | while IFS= read -r -d '' path; do
  if [[ "$path" == *.dot ]]; then
    render_one "$path"
  fi
  done
