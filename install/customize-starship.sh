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
[ -f "$CONFIG" ] || { echo "starship.toml not found at $CONFIG" >&2; exit 1; }

MODULES=(aws azure gcloud)

currently_enabled() {
  awk '
    /^\[/ { gsub(/[][]/, "", $0); section=$0; next }
    section ~ /^(aws|azure|gcloud)$/ && $0 ~ /^disabled[[:space:]]*=[[:space:]]*false/ {
      print section
    }
  ' "$CONFIG"
}

enabled_before="$(currently_enabled | paste -sd, - || true)"

if command -v fzf >/dev/null 2>&1; then
  chosen="$(
    printf '%s\n' "${MODULES[@]}" | fzf \
      --multi --height='~30%' --reverse \
      --prompt='Enable cloud modules> ' \
      --header=$'Tab: toggle · Enter: confirm · currently enabled: '"${enabled_before:-none}" \
      || true
  )"
else
  echo "fzf not installed — falling back to y/n prompts."
  chosen=""
  for m in "${MODULES[@]}"; do
    default="n"; currently_enabled | grep -qxF "$m" && default="y"
    read -r -p "Enable $m? [y/n] (current: $default) " reply </dev/tty || reply=""
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
echo "Starship cloud modules now enabled:"
enabled_now="$(currently_enabled | paste -sd, - || true)"
echo "  ${enabled_now:-none}"
if [ "$enabled_before" != "$enabled_now" ]; then
  echo
  echo "xdg/starship.toml was modified. Review with: git -C \"$(cd "$SCRIPT_DIR/.." && pwd)\" diff xdg/starship.toml"
fi
