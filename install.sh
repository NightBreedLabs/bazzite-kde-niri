#!/usr/bin/env bash
# User-scoped settings installer. Does not install packages, change GPU settings,
# edit PAM files, remove KDE, or touch system directories.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mode="${1:---dry-run}"
[[ $# -le 1 && ( "$mode" == '--dry-run' || "$mode" == '--apply' ) ]] || { echo 'Usage: ./install.sh [--dry-run|--apply]' >&2; exit 2; }

items=(
  'config/niri|.config/niri|dir'
  'config/xdg-desktop-portal/niri-portals.conf|.config/xdg-desktop-portal/niri-portals.conf|file'
  'config/noctalia/95-bazzite-kde-niri.toml|.config/noctalia/95-bazzite-kde-niri.toml|file'
)
echo 'Bazzite KDE + Niri community configuration'
echo '------------------------------------------'
echo 'Will install ONLY user configuration:'
for item in "${items[@]}"; do IFS='|' read -r src dst kind <<<"$item"; printf '  %s -> ~/%s\n' "$src" "$dst"; done
if [[ "$mode" == '--dry-run' ]]; then
  echo 'DRY RUN: no files changed. Use ./preflight.sh, then ./install.sh --apply when ready.'
  exit 0
fi
if ! command -v niri >/dev/null 2>&1 || ! command -v noctalia >/dev/null 2>&1; then
  echo 'Niri and Noctalia must be installed first (and the machine rebooted).' >&2; exit 1
fi
for cmd in konsole dolphin; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Missing KDE program: $cmd. Restore Bazzite KDE first." >&2; exit 1; }
done
if [[ ! -x /usr/libexec/pam_kwallet_init ]]; then
  echo 'Missing /usr/libexec/pam_kwallet_init. Fix KWallet/PAM integration first.' >&2; exit 1
fi
# Validate the source before touching live configuration.
niri validate --config "$root/config/niri/config.kdl"
# The backup path is deliberately inside HOME, not in the Git checkout.
backup_base="${XDG_STATE_HOME:-$HOME/.local/state}/bazzite-kde-niri/backups"
mkdir -p "$backup_base"
chmod 700 "$(dirname "$backup_base")" "$backup_base" || true
backup="$backup_base/$(date +%Y%m%d-%H%M%S)-$$"
mkdir -m 700 "$backup"
printf '%s\n' 'user-config-backup-v1' > "$backup/FORMAT"
for item in "${items[@]}"; do
  IFS='|' read -r src rel kind <<<"$item"
  original="$HOME/$rel"
  if [[ -e "$original" || -L "$original" ]]; then
    if [[ -L "$original" ]]; then
      echo "Refusing to replace symlink: $original (review manually)." >&2; exit 1
    fi
    [[ "$kind" == 'dir' && -d "$original" || "$kind" == 'file' && -f "$original" ]] || { echo "Unexpected file type: $original" >&2; exit 1; }
    printf 'existing|%s|%s\n' "$rel" "$kind" >> "$backup/MANIFEST"
    mkdir -p "$backup/$(dirname "$rel")"
    cp -a "$original" "$backup/$rel"
  else
    printf 'missing|%s|%s\n' "$rel" "$kind" >> "$backup/MANIFEST"
  fi
done
# Second pass: write after all backups are finished.
for item in "${items[@]}"; do
  IFS='|' read -r src rel kind <<<"$item"
  target="$HOME/$rel"
  mkdir -p "$(dirname "$target")"
  if [[ "$kind" == 'dir' ]]; then
    # Move old Niri settings aside without deleting them.
    if [[ -e "$target" ]]; then mv "$target" "$backup/was-active-niri"; fi
    cp -a "$root/$src" "$target"
  else
    cp "$root/$src" "$target"
  fi
  printf '[installed] ~/%s\n' "$rel"
done
printf '%s\n' "$backup" > "${XDG_STATE_HOME:-$HOME/.local/state}/bazzite-kde-niri/last-backup"
echo ''
echo "BACKUP: $backup"
echo 'Now log out, choose Niri at the login screen, then run ./doctor.sh.'
echo 'To restore your old settings, use: ./restore.sh "'"$backup"'" --apply'
