#!/bin/bash
# Linux bootstrap (Debian/Ubuntu, Fedora, Arch). Invoked by install.sh after
# OS detection, or directly:
#
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/sleistner/dotfiles/HEAD/install/install-linux.sh)"
#
# Handles only the parts with clean cross-distro automation: prerequisites,
# clone, ./setup symlinks, oh-my-zsh. The modern-CLI toolchain, Docker, and
# terminal/font install are interactive/opinionated enough that they stay in
# docs/install-linux.md §6–8.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/common.sh" ]; then
  # shellcheck source=./common.sh
  . "$SCRIPT_DIR/common.sh"
else
  eval "$(curl -fsSL https://raw.githubusercontent.com/sleistner/dotfiles/HEAD/install/common.sh)"
fi

if [ "$(uname -s)" != "Linux" ]; then
  echo "install-linux.sh: not running on Linux (uname=$(uname -s))." >&2
  exit 1
fi

detect_pm() {
  if command -v apt-get >/dev/null 2>&1; then echo apt
  elif command -v dnf >/dev/null 2>&1; then echo dnf
  elif command -v pacman >/dev/null 2>&1; then echo pacman
  else echo unknown
  fi
}
PM="$(detect_pm)"

# 1. System prerequisites
step "System prerequisites (git, curl, zsh, build tools)"
case "$PM" in
  apt)
    sudo apt-get update
    sudo apt-get install -y git curl zsh build-essential
    ;;
  dnf)
    sudo dnf install -y git curl zsh @development-tools
    ;;
  pacman)
    sudo pacman -Sy --needed --noconfirm git curl zsh base-devel
    ;;
  *)
    warn "unknown package manager — install git/curl/zsh/build-tools manually, then re-run"
    exit 1
    ;;
esac
ok "prerequisites installed"

# 2. Default shell
step "Default shell"
if [ "$(basename "${SHELL:-}")" = "zsh" ]; then
  ok "already zsh"
else
  if prompt_yes_no "Change default shell to zsh (requires sign-out to take effect)?" Y; then
    chsh -s "$(command -v zsh)" || warn "chsh failed — run manually later"
    ok "default shell set to zsh (sign out + back in to apply)"
  else
    ok "skipped chsh"
  fi
fi

# 3. Clone + symlinks
clone_repo
run_setup_symlinks

# 4. oh-my-zsh + zsh-autosuggestions
install_oh_my_zsh

cat <<EOF

${c_green}Core automated steps complete.${c_reset}

Still to do manually (see docs/install-linux.md §2, §6–9):
  • SSH access for GitHub (1Password agent or ssh-keygen), if you cloned via HTTPS.
  • Install modern CLI toolchain (mise, starship, cargo installs, gh). §6
  • Docker engine. §7
  • Terminal emulator + nerd font. §8
  • atuin register, nvim first-launch, mise install per project. §9
EOF
