#!/usr/bin/env bash
# preflight-conflicts.sh — clear up issues that make `brew bundle` fail.
#
# Checks:
#   1. Formulae installed outside brew (npm/cargo/pip) that collide with
#      Brewfile entries — offers to uninstall the pre-existing copy.
#   2. Casks where the .app already exists in /Applications (dragged from a
#      dmg or installed via the App Store) — offers to move to Trash.
#   3. Broken kegs: brew thinks a formula is installed but its Cellar dir
#      is gone (causes `No such keg`/`Upgrading X has failed!`) — offers to
#      `brew reinstall`.
#
# Runs automatically from install/install-macos.sh before `brew bundle` and is
# also exposed as `dotctl preflight` for standalone use.
#
# Usage:
#   install/preflight-conflicts.sh          interactive (per-item prompt)
#   install/preflight-conflicts.sh -y       assume yes to every prompt
#   install/preflight-conflicts.sh -n       report only, don't touch anything
#   install/preflight-conflicts.sh -h       this help

set -u

ASSUME_YES=0
REPORT_ONLY=0

for arg in "$@"; do
  case "$arg" in
    -h | --help)
      sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    -y | --yes) ASSUME_YES=1 ;;
    -n | --report) REPORT_ONLY=1 ;;
    *)
      printf 'preflight-conflicts: unknown option: %s\n' "$arg" >&2
      exit 2
      ;;
  esac
done

# binary_on_path : brew_formula : npm_package (or "-") : cargo_crate (or "-")
# brew_formula is used to skip already-brewed copies and nothing else.
# npm/cargo package names drive the suggested uninstall command.
CANDIDATES=(
  "codex:codex:@openai/codex:-"
  "sqlx:sqlx-cli:-:sqlx-cli"
  "pnpm:pnpm:pnpm:-"
  "tree-sitter:tree-sitter-cli:tree-sitter-cli:tree-sitter-cli"
  "cargo-lambda:cargo-lambda:-:cargo-lambda"
)

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)
BREWFILE="${BREWFILE:-$SCRIPT_DIR/../Brewfile}"

c_blue=$'\033[1;34m'
c_green=$'\033[1;32m'
c_yellow=$'\033[1;33m'
c_reset=$'\033[0m'

section() { printf '\n%s==>%s %s\n' "$c_blue" "$c_reset" "$1"; }
ok()      { printf '%s✓%s %s\n'     "$c_green" "$c_reset" "$1"; }
warn()    { printf '%s!%s %s\n'     "$c_yellow" "$c_reset" "$1"; }

BREW_PREFIX=""
if command -v brew >/dev/null 2>&1; then
  BREW_PREFIX=$(brew --prefix 2>/dev/null || true)
fi

confirm() {
  local msg="$1"
  [ "$ASSUME_YES" -eq 1 ] && return 0
  if [ ! -t 0 ] && [ ! -r /dev/tty ]; then
    return 1
  fi
  printf '%s [y/N] ' "$msg"
  read -r reply </dev/tty || reply=""
  case "$reply" in [Yy]*) return 0 ;; *) return 1 ;; esac
}

# Return 0 if $1 resolves to a path under Homebrew's prefix.
is_brew_owned() {
  local path="$1"
  [ -n "$BREW_PREFIX" ] || return 1
  case "$path" in "$BREW_PREFIX"/*) return 0 ;; esac
  # Also accept Cellar paths via realpath (brew bin entries are symlinks).
  local real
  real=$(realpath "$path" 2>/dev/null || printf '%s' "$path")
  case "$real" in "$BREW_PREFIX"/*) return 0 ;; esac
  return 1
}

uninstall_via() {
  local bin="$1" npm_pkg="$2" cargo_pkg="$3" path="$4"

  # Prefer the manager the binary actually came from.
  case "$path" in
    */.cargo/bin/*)
      if [ "$cargo_pkg" != "-" ] && command -v cargo >/dev/null 2>&1; then
        printf '  $ cargo uninstall %s\n' "$cargo_pkg"
        cargo uninstall "$cargo_pkg" && return 0
      fi
      ;;
    */node_modules/*|*/.npm/*|*/.nvm/*|*/n/versions/*)
      if [ "$npm_pkg" != "-" ] && command -v npm >/dev/null 2>&1; then
        printf '  $ npm uninstall -g %s\n' "$npm_pkg"
        npm uninstall -g "$npm_pkg" && return 0
      fi
      ;;
  esac

  # Fall back to whichever manager claims it.
  if [ "$npm_pkg" != "-" ] && command -v npm >/dev/null 2>&1; then
    if npm ls -g --depth=0 "$npm_pkg" >/dev/null 2>&1; then
      printf '  $ npm uninstall -g %s\n' "$npm_pkg"
      npm uninstall -g "$npm_pkg" && return 0
    fi
  fi
  if [ "$cargo_pkg" != "-" ] && command -v cargo >/dev/null 2>&1; then
    if cargo install --list 2>/dev/null | grep -q "^$cargo_pkg "; then
      printf '  $ cargo uninstall %s\n' "$cargo_pkg"
      cargo uninstall "$cargo_pkg" && return 0
    fi
  fi

  warn "could not determine a package manager for $path — uninstall it manually, then re-run."
  return 1
}

section "Pre-existing installs that would collide with brew bundle"

found_any=0
for entry in "${CANDIDATES[@]}"; do
  IFS=':' read -r bin formula npm_pkg cargo_pkg <<<"$entry"

  path=$(command -v "$bin" 2>/dev/null || true)
  [ -n "$path" ] || continue
  is_brew_owned "$path" && continue

  found_any=1
  version=$("$bin" --version 2>/dev/null | head -n1 || true)
  [ -n "$version" ] || version="(version unknown)"
  printf '\n  %s\n    path:    %s\n    version: %s\n    brew:    %s\n' \
    "$bin" "$path" "$version" "$formula"

  if [ "$REPORT_ONLY" -eq 1 ]; then
    continue
  fi

  if confirm "  Replace with the Homebrew version?"; then
    if uninstall_via "$bin" "$npm_pkg" "$cargo_pkg" "$path"; then
      ok "$bin uninstalled — brew bundle will install the Homebrew copy."
    fi
  else
    warn "$bin kept as-is. brew bundle may fail to install $formula."
  fi
done

# Generic cask conflict check: for every cask declared in Brewfile, ask brew
# which .app(s) it installs, then flag any that already exist in /Applications
# outside of brew's ownership.
if command -v brew >/dev/null 2>&1 && [ -f "$BREWFILE" ]; then
  casks=$(sed -n 's/^cask "\([^"]*\)".*/\1/p' "$BREWFILE")
  for cask in $casks; do
    # Skip casks brew already manages — brew owns the .app in that case.
    brew list --cask "$cask" >/dev/null 2>&1 && continue

    # Parse "==> Artifacts" block for lines like "SomeApp.app (App)".
    app_names=$(brew info --cask "$cask" 2>/dev/null \
      | sed -n 's/ (App)$//p' \
      | grep '\.app$' || true)
    [ -n "$app_names" ] || continue

    # IFS change scoped via while-read so app names with spaces stay intact.
    while IFS= read -r app; do
      [ -n "$app" ] || continue
      app_path="/Applications/$app"
      [ -e "$app_path" ] || continue

      found_any=1
      version_plist="$app_path/Contents/Info.plist"
      version=""
      if [ -f "$version_plist" ] && command -v defaults >/dev/null 2>&1; then
        version=$(defaults read "$version_plist" CFBundleShortVersionString 2>/dev/null || true)
      fi
      [ -n "$version" ] || version="(version unknown)"
      printf '\n  %s\n    path:    %s\n    version: %s\n    brew:    %s (cask)\n' \
        "$app" "$app_path" "$version" "$cask"

      if [ "$REPORT_ONLY" -eq 1 ]; then
        continue
      fi

      if confirm "  Move to Trash so brew can install the cask?"; then
        if osascript -e "tell application \"Finder\" to delete POSIX file \"$app_path\"" >/dev/null; then
          ok "$app trashed — brew bundle will install the cask copy."
        else
          warn "failed to trash $app_path (Finder automation permission? admin rights?)."
        fi
      else
        warn "$app kept as-is. brew bundle may fail to install $cask."
      fi
    done <<<"$app_names"
  done
fi

if [ "$found_any" -eq 0 ]; then
  ok "no conflicts found."
fi

# ---- Broken kegs --------------------------------------------------------
# brew's metadata can say a formula is installed while its Cellar directory
# is missing (interrupted install, manual rm, bad cleanup). `brew bundle` then
# tries to upgrade and fails with "No such keg". Detect and offer reinstall.
section "Broken Homebrew kegs"

if ! command -v brew >/dev/null 2>&1; then
  printf '  [skip] brew not installed.\n'
else
  cellar=$(brew --cellar 2>/dev/null)
  broken=()
  if [ -n "$cellar" ]; then
    while IFS= read -r formula; do
      [ -n "$formula" ] || continue
      [ -d "$cellar/$formula" ] || broken+=("$formula")
    done < <(brew list --formula 2>/dev/null)
  fi

  if [ ${#broken[@]} -eq 0 ]; then
    ok "all kegs intact."
  else
    printf '  brew lists these as installed, but their Cellar dirs are missing:\n'
    for f in "${broken[@]}"; do printf '    - %s\n' "$f"; done

    if [ "$REPORT_ONLY" -eq 1 ]; then
      :
    elif confirm "  Reinstall them now? (fixes 'No such keg' from brew bundle)"; then
      printf '  $ brew reinstall %s\n' "${broken[*]}"
      brew reinstall "${broken[@]}" || warn "brew reinstall returned non-zero — inspect output above."
    else
      warn "kept as-is. brew bundle may fail with 'No such keg'."
    fi
  fi
fi
