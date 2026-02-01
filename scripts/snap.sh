#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SNAP_DIR="$ROOT/.snapshots"
TS="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$SNAP_DIR"

cp -p "$ROOT/docs/diagrams/dot/example.dot" "$SNAP_DIR/example.dot.$TS" 2>/dev/null || true
cp -p "$ROOT/docs/diagrams/svg/example.svg" "$SNAP_DIR/example.svg.$TS" 2>/dev/null || true

# Optional: keep a pointer to the latest snapshot
ln -sfn "$SNAP_DIR"/example.dot."$TS" "$SNAP_DIR"/example.dot.latest
ln -sfn "$SNAP_DIR"/example.svg."$TS" "$SNAP_DIR"/example.svg.latest

echo "Snapshot saved: $SNAP_DIR (timestamp $TS)"
