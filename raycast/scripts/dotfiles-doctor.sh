#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dotfiles Doctor
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🩺
# @raycast.packageName dotctl
# @raycast.description Check for drift between the Brewfile, what's installed, and the docs.
# @raycast.author Stefan Leistner
# @raycast.authorURL https://github.com/sleistner

. "$(dirname "$0")/.lib.sh"

# No tty here, so doctor prints its fix commands instead of prompting.
# Drift exits 1; swallow it so Raycast renders the report rather than an error.
dotctl doctor || true
