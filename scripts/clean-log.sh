#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: ./scripts/clean-log.sh <input.log> [output.log]" >&2
  exit 1
fi

IN="$1"
OUT="${2:-${IN%.log}.cleaned.log}"

if [[ ! -f "$IN" ]]; then
  echo "Input file not found: $IN" >&2
  exit 1
fi

# First remove backspaces/overstrikes, then strip ANSI/OSC sequences
col -bx < "$IN" | \
python3 -c "import re, sys; text=sys.stdin.read(); text=re.sub(r'\x1b\\[[0-9;?]*[ -/]*[@-~]','',text); text=re.sub(r'\x1b\\][^\x07]*\x07','',text); sys.stdout.write(text)" \
> "$OUT"

printf "Cleaned log written to %s\n" "$OUT"
