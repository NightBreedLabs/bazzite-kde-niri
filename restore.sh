#!/usr/bin/env bash
# Restore user settings from a backup made by ./install.sh.
set -euo pipefail
if [[ $# -ne 2 || "$2" != '--apply' ]]; then
  echo 'Usage: ./restore.sh /ABSOLUTE/BACKUP/FOLDER --apply'
  echo 'Move aside current project-managed settings, then restore saved ones.'
  echo 'This script never removes KDE, Niri, Noctalia, or any RPM packages.'
  exit 2
fi
backup="$(realpath -- "$1")"
[[ -f "$backup/FORMAT" && "$(cat "$backup/FORMAT")" == 'user-config-backup-v1' && -f "$backup/MANIFEST" ]] || { echo 'Not a valid backup.' >&2; exit 1; }
[[ "$backup" == "$HOME"/.local/state/bazzite-kde-niri/backups/* || "$backup" == "${XDG_STATE_HOME:-$HOME/.local/state}"/bazzite-kde-niri/backups/* ]] || { echo 'Unexpected backup location.' >&2; exit 1; }
now="$(date +%Y%m%d-%H%M%S)-$$"
stash="${XDG_STATE_HOME:-$HOME/.local/state}/bazzite-kde-niri/replaced-on-restore/$now"
mkdir -p "$stash"
while IFS='|' read -r state rel kind; do
  [[ "$state" == 'existing' || "$state" == 'missing' ]] || exit 1
  case "$rel" in
    .config/niri|.config/xdg-desktop-portal/niri-portals.conf|.config/noctalia/95-bazzite-kde-niri.toml) ;;
    *) echo 'Unknown path in backup manifest; refusing.' >&2; exit 1;;
  esac
  target="$HOME/$rel"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$stash/$(dirname "$rel")"
    mv "$target" "$stash/$rel"
  fi
  if [[ "$state" == existing ]]; then
    mkdir -p "$(dirname "$target")"
    cp -a "$backup/$rel" "$target"
    echo "Restored $rel"
  else
    echo "Originally absent, now absent: $rel"
  fi
done < "$backup/MANIFEST"
echo "Current settings were preserved at: $stash"
echo 'Log out and choose Plasma or Niri to see the restored settings.'
