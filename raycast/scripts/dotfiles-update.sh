#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dotfiles Update
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ⬆️
# @raycast.packageName dotctl
# @raycast.description Open a terminal and run pull + preflight + brew bundle + setup.
# @raycast.author Stefan Leistner
# @raycast.authorURL https://github.com/sleistner

. "$(dirname "$0")/.lib.sh"

# Long-running, and cask installs prompt for sudo — needs a real terminal.
run_in_terminal dotctl update
