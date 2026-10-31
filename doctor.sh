#!/usr/bin/env bash
# No changes. Check technical preconditions, not whether an app truly works.
set -uo pipefail
errors=0
ok() { echo "[OK]  $*"; }
note() { echo "[??]  $*"; errors=$((errors+1)); }
for cmd in niri noctalia konsole dolphin; do
  if command -v "$cmd" >/dev/null 2>&1; then ok "$cmd present"; else note "$cmd missing"; fi
done
if command -v niri >/dev/null 2>&1; then
  if niri validate --config "$HOME/.config/niri/config.kdl"; then ok 'Niri config parses'; else note 'Niri config failed validation'; fi
fi
if [[ -f "$HOME/.config/xdg-desktop-portal/niri-portals.conf" ]]; then
  p="$HOME/.config/xdg-desktop-portal/niri-portals.conf"
  grep -Fxq 'org.freedesktop.impl.portal.FileChooser=gtk;' "$p" && ok 'GTK picker preferred in Niri config' || note 'GTK picker preference missing'
  grep -Fxq 'org.freedesktop.impl.portal.Secret=kwallet;' "$p" && ok 'KWallet portal preferred in Niri config' || note 'KWallet portal preference missing'
else note 'Niri portal configuration absent'; fi
for f in niri.desktop plasma.desktop; do
  if [[ -f "/usr/share/wayland-sessions/$f" ]]; then ok "Login session $f exists"; else note "Login session $f not found"; fi
done
if command -v xwayland-satellite >/dev/null 2>&1; then ok 'Xwayland Satellite present for X11 games'; else note 'Xwayland Satellite missing'; fi
if [[ -x /usr/libexec/pam_kwallet_init ]]; then ok 'KWallet PAM helper exists'; else note 'KWallet PAM helper missing'; fi
printf '\nResult: %d missing/unverified checks.\n' "$errors"
echo 'This cannot prove KWallet unlock, dialogs, screen sharing or a game launch. Test them in Niri and Plasma.'
if (( errors > 0 )); then exit 1; fi
