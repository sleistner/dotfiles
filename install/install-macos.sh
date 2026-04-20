#!/bin/bash
# macOS bootstrap. Invoked by install.sh after OS detection, or directly:
#
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/sleistner/dotfiles/HEAD/install/install-macos.sh)"
#
# Idempotent. See docs/install-macos.md for what this leaves to the user.

set -euo pipefail

# When this script is curl|bash'd standalone, common.sh lives beside the clone
# we're about to create — so fetch it over the network. When invoked from a
# checkout, source it directly.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/common.sh" ]; then
  # shellcheck source=./common.sh
  . "$SCRIPT_DIR/common.sh"
else
  eval "$(curl -fsSL https://raw.githubusercontent.com/sleistner/dotfiles/HEAD/install/common.sh)"
fi

if [ "$(uname -s)" != "Darwin" ]; then
  echo "install-macos.sh: not running on macOS (uname=$(uname -s))." >&2
  exit 1
fi

# 1. Xcode Command Line Tools
step "Xcode Command Line Tools"
if xcode-select -p >/dev/null 2>&1; then
  ok "already installed"
else
  xcode-select --install || true
  echo "Waiting for the Xcode CLT installer dialog to finish..."
  until xcode-select -p >/dev/null 2>&1; do sleep 10; done
  ok "installed"
fi

# 2. Homebrew
step "Homebrew"
if command -v brew >/dev/null 2>&1; then
  ok "already installed ($(brew --prefix))"
else
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ok "installed"
fi
BREW_PREFIX="$(/opt/homebrew/bin/brew --prefix 2>/dev/null || /usr/local/bin/brew --prefix)"
eval "$("$BREW_PREFIX/bin/brew" shellenv)"

# 3. 1Password (optional) — install + pause for SSH agent setup before cloning.
step "1Password (optional)"
if [ -d "/Applications/1Password.app" ] || brew list --cask 1password >/dev/null 2>&1; then
  ok "1Password already installed"
elif prompt_yes_no "Install 1Password + 1Password CLI for SSH agent and git signing?" Y; then
  brew install --cask 1password 1password-cli
  cat <<'EOF'

1Password installed. Before continuing:
  1. Launch 1Password and sign in.
  2. Settings → Developer → enable "Use the SSH agent".
  3. Make sure your GitHub SSH key is saved as an Item.

Press Enter when ready (or Ctrl-C to abort and re-run later).
EOF
  read -r _ </dev/tty || true
  ok "1Password ready"
else
  ok "skipped 1Password (gitconfig SSH-signing block will be inert)"
fi

# 4. Clone + symlinks
clone_repo
run_setup_symlinks

# 5. Brewfile
step "brew bundle (this takes 10–20 min on a fresh machine)"
(cd "$DOTFILES_DIR" && brew bundle --file=Brewfile)
ok "Brewfile installed"

# 6. oh-my-zsh + zsh-autosuggestions
install_oh_my_zsh

# 7. Optional: pick cloud-provider modules for the Starship prompt.
step "Starship prompt customization (optional)"
if prompt_yes_no "Pick which cloud modules (aws/azure/gcloud) show in the prompt?" N; then
  bash "$DOTFILES_DIR/install/customize-starship.sh"
else
  ok "skipped (edit xdg/starship.toml or re-run install/customize-starship.sh anytime)"
fi

cat <<EOF

${c_green}All automated steps complete.${c_reset}

Next — the manual bits (see docs/install-macos.md §9):
  • Open a fresh terminal so ~/.zshrc reloads.
  • Launch OrbStack, Ghostty, Raycast once; grant accessibility perms.
  • atuin register -u <name> -e <email>   (or 'atuin login' if existing).
  • nvim   (lazy.nvim bootstraps plugins on first launch).
  • mise install   inside any project with a mise.toml.

Run 'tools' for the grouped CLI reference.
EOF
