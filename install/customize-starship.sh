#!/usr/bin/env bash
# Interactive selector for cloud-provider modules in the Starship prompt.
# Edits xdg/starship.toml in place (which is symlinked into ~/.config/).
# Safe to re-run: currently-enabled modules are pre-selected.
#
# Invoked optionally at the end of install/install-{macos,linux}.sh, or run
# standalone from the repo root:  bash install/customize-starship.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
CONFIG="$(cd "$SCRIPT_DIR/.." && pwd)/xdg/starship.toml"
[ -f "$CONFIG" ] || {
  echo "starship.toml not found at $CONFIG" >&2
  exit 1
}

MODULES=(aws azure gcloud)

currently_enabled() {
  awk '
    /^\[/ { gsub(/[][]/, "", $0); section=$0; next }
    section ~ /^(aws|azure|gcloud)$/ && $0 ~ /^disabled[[:space:]]*=[[:space:]]*false/ {
      print section
    }
  ' "$CONFIG"
}

enabled_before_list="$(currently_enabled)"
enabled_before="$(printf '%s' "$enabled_before_list" | paste -sd, - || true)"

is_enabled() { printf '%s\n' "$enabled_before_list" | grep -qxF "$1"; }

mark_for() { is_enabled "$1" && printf '[x]' || printf '[ ]'; }

# Build list with a visible checkbox so current state is obvious.
#   [x] aws
#   [ ] azure
list=""
for m in "${MODULES[@]}"; do
  list+="$(mark_for "$m") $m"$'\n'
done

if command -v fzf >/dev/null 2>&1; then
  # Pre-select currently-enabled rows so "Enter with no changes" is a no-op.
  # fzf 0.44+ supports pos(N)+select via the `start` binding.
  preselect=""
  for i in "${!MODULES[@]}"; do
    if is_enabled "${MODULES[$i]}"; then
      preselect+="pos($((i + 1)))+select+"
    fi
  done
  preselect="${preselect%+}"

  bind_args=()
  [ -n "$preselect" ] && bind_args=(--bind "start:$preselect")

  chosen="$(
    printf '%s' "$list" | fzf \
      --multi --height='~30%' --reverse \
      --prompt='Enable cloud modules> ' \
      --header=$'Tab: toggle · Enter: confirm · [x] = currently enabled' \
      "${bind_args[@]}" ||
      true
  )"
  # Strip the "[x] "/"[ ] " prefix to get bare module names.
  chosen="$(printf '%s' "$chosen" | sed -E 's/^\[.\] //')"
else
  echo "fzf not installed — falling back to y/n prompts."
  chosen=""
  for m in "${MODULES[@]}"; do
    if is_enabled "$m"; then
      mark="[x]"
      default="y"
    else
      mark="[ ]"
      default="n"
    fi
    read -r -p "$mark $m — enable? [y/n] (default: $default) " reply </dev/tty || reply=""
    reply="${reply:-$default}"
    case "$reply" in [Yy]*) chosen+="$m"$'\n' ;; esac
  done
fi

toggle_section() {
  local mod="$1" val="$2" tmp
  if grep -q "^\[$mod\]" "$CONFIG"; then
    tmp="$(mktemp)"
    awk -v section="[$mod]" -v value="$val" '
      /^\[/ { in_s = ($0 == section) ? 1 : 0 }
      in_s && /^disabled[[:space:]]*=/ { print "disabled = " value; next }
      { print }
    ' "$CONFIG" >"$tmp" && mv "$tmp" "$CONFIG"
  else
    printf '\n[%s]\ndisabled = %s\n' "$mod" "$val" >>"$CONFIG"
  fi
}

for m in "${MODULES[@]}"; do
  if printf '%s\n' "$chosen" | grep -qxF "$m"; then
    toggle_section "$m" false
  else
    toggle_section "$m" true
  fi
done

echo
echo "Starship cloud modules:"
enabled_now_list="$(currently_enabled)"
for m in "${MODULES[@]}"; do
  if printf '%s\n' "$enabled_now_list" | grep -qxF "$m"; then mark="[x]"; else mark="[ ]"; fi
  printf '  %s %s\n' "$mark" "$m"
done
enabled_now="$(printf '%s' "$enabled_now_list" | paste -sd, - || true)"
if [ "$enabled_before" != "$enabled_now" ]; then
  echo
  echo "xdg/starship.toml was modified. Review with: git -C \"$(cd "$SCRIPT_DIR/.." && pwd)\" diff xdg/starship.toml"
fi
