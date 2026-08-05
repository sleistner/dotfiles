#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dotfiles Update + Upgrade
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ⏫
# @raycast.packageName dotctl
# @raycast.description Open a terminal and run dotctl update followed by brew upgrade.
# @raycast.author Stefan Leistner
# @raycast.authorURL https://github.com/sleistner

. "$(dirname "$0")/.lib.sh"

run_in_terminal dotctl update -u
