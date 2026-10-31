#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for script in preflight.sh install-system.sh install.sh restore.sh doctor.sh; do
  bash -n "$root/$script"
done
[[ "$(find "$root/config/niri/cfg" -name '*.kdl' | wc -l)" -eq 7 ]] || exit 1
grep -Fxq 'org.freedesktop.impl.portal.FileChooser=gtk;' "$root/config/xdg-desktop-portal/niri-portals.conf"
grep -Fxq 'org.freedesktop.impl.portal.Secret=kwallet;' "$root/config/xdg-desktop-portal/niri-portals.conf"
grep -Fq 'spawn "konsole"' "$root/config/niri/cfg/shortcuts.kdl"
grep -Fq 'spawn "dolphin"' "$root/config/niri/cfg/shortcuts.kdl"
grep -Fq 'spawn-at-startup "noctalia"' "$root/config/niri/cfg/startup.kdl"
! grep -R -Ei --include='*.kdl' --include='*.toml' 'antigravity|codex|ollama|josenightbreed|192\.168\.8\.|/home/[a-z]+/' "$root/config"
"$root/install.sh" --dry-run >/dev/null
printf '[PASS] Shell syntax, expected user settings, source privacy, and dry run\n'
echo '[NOTE] Niri KDL semantic validation needs the actual Niri 26.04+ binary on Bazzite.'
