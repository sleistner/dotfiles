#!/bin/bash
# One-shot bootstrap dispatcher. Detects the OS and hands off to the matching
# install/install-<os>.sh.
#
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/sleistner/dotfiles/HEAD/install.sh)"
#
# Idempotent — safe to re-run.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
RAW_BASE="https://raw.githubusercontent.com/sleistner/dotfiles/HEAD/install"

dispatch() {
  local script="$1"
  if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/install/$script" ]; then
    exec bash "$SCRIPT_DIR/install/$script"
  else
    exec bash -c "$(curl -fsSL "$RAW_BASE/$script")"
  fi
}

case "$(uname -s)" in
  Darwin) dispatch install-macos.sh ;;
  Linux)  dispatch install-linux.sh ;;
  *)
    echo "Unsupported OS: $(uname -s). macOS and Linux only." >&2
    exit 1
    ;;
esac
