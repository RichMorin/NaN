#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WATCH_DIRS=("$ROOT/docs")

if ! command -v fswatch >/dev/null 2>&1; then
  echo "fswatch not found. Install it with: brew install fswatch" >&2
  exit 1
fi

build_once() {
  "$ROOT/scripts/build-gen.sh"
  bundle exec jekyll build -s "$ROOT/_site/gen/docs" -d "$ROOT/_site/site"
}

build_once

echo "Watching ${WATCH_DIRS[*]} for changes..."
fswatch -0 "${WATCH_DIRS[@]}" | while IFS= read -r -d '' path; do
  case "$path" in
    *.md|*.dot|*.yml|*.yaml|*.html|*.css|*.js)
      echo "Change detected: $path"
      build_once
      ;;
  esac
done
