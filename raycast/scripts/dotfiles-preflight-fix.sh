#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dotfiles Preflight Fix
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🧹
# @raycast.packageName dotctl
# @raycast.description Open a terminal and walk the preflight conflicts interactively.
# @raycast.author Stefan Leistner
# @raycast.authorURL https://github.com/sleistner

. "$(dirname "$0")/.lib.sh"

# Prompts per item and can move apps to Trash, so it needs a real terminal.
run_in_terminal dotctl preflight
