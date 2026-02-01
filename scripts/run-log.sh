#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="${LOG_FILE:-/Users/rdm/NaN/logs/session.log}"

if [[ $# -lt 1 ]]; then
  echo "Usage: LOG_FILE=path/to/log ./scripts/run-log.sh <command> [args...]" >&2
  exit 1
fi

{
  echo "\n[$(date '+%Y-%m-%d %H:%M:%S')] $*";
  "$@";
} 2>&1 | tee -a "$LOG_FILE"
