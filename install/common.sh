#!/usr/bin/env bash
# Shared helpers for install/install-{macos,linux}.sh. Sourced, not run.

REPO_URL_SSH="git@github.com:sleistner/dotfiles.git"
REPO_URL_HTTPS="https://github.com/sleistner/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/config/dotfiles}"

c_blue=$'\033[1;34m'
c_green=$'\033[1;32m'
c_yellow=$'\033[1;33m'
c_reset=$'\033[0m'

step() { printf "\n%s==>%s %s\n" "$c_blue" "$c_reset" "$1"; }
ok() { printf "%s✓%s %s\n" "$c_green" "$c_reset" "$1"; }
warn() { printf "%s!%s %s\n" "$c_yellow" "$c_reset" "$1"; }

prompt_yes_no() {
  # prompt_yes_no "Question?" default(Y|N) -> returns 0 for yes, 1 for no
  local question="$1" default="${2:-Y}" reply hint
  [ "$default" = "Y" ] && hint="[Y/n]" || hint="[y/N]"
  if [ ! -t 0 ] && [ ! -r /dev/tty ]; then
    [ "$default" = "Y" ] && return 0 || return 1
  fi
  printf "%s %s " "$question" "$hint"
  read -r reply </dev/tty || reply=""
  [ -z "$reply" ] && reply="$default"
  case "$reply" in
    [Yy]*) return 0 ;;
    *) return 1 ;;
  esac
}

clone_repo() {
  step "Clone sleistner/dotfiles into $DOTFILES_DIR"
  if [ -d "$DOTFILES_DIR/.git" ]; then
    ok "already cloned"
    return
  fi
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  if git ls-remote "$REPO_URL_SSH" >/dev/null 2>&1; then
    git clone "$REPO_URL_SSH" "$DOTFILES_DIR"
  else
    warn "SSH clone failed; falling back to HTTPS"
    git clone "$REPO_URL_HTTPS" "$DOTFILES_DIR"
  fi
  ok "cloned"
}

run_setup_symlinks() {
  step "Create symlinks (./setup)"
  (cd "$DOTFILES_DIR" && ./setup)
  ok "symlinks in place"
}

install_zsh_plugins() {
  step "zsh plugins"
  local name dest brew_share=""
  if command -v brew >/dev/null 2>&1; then
    brew_share="$(brew --prefix)/share"
  fi
  for name in zsh-autosuggestions zsh-syntax-highlighting; do
    dest="$HOME/.zsh/plugins/$name"
    if [ -n "$brew_share" ] && [ -r "$brew_share/$name/$name.zsh" ]; then
      ok "$name provided by Homebrew"
    elif [ -d "$dest" ]; then
      ok "$name already installed"
    else
      git clone "https://github.com/zsh-users/$name" "$dest"
      ok "$name installed"
    fi
  done
}
