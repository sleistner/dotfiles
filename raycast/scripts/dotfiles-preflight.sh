#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dotfiles Preflight
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon ✈️
# @raycast.packageName dotctl
# @raycast.description Report conflicts and broken kegs that would make brew bundle fail.
# @raycast.author Stefan Leistner
# @raycast.authorURL https://github.com/sleistner

. "$(dirname "$0")/.lib.sh"

# -n keeps this read-only; "Dotfiles Preflight Fix" does the interactive pass.
exec dotctl preflight -n
