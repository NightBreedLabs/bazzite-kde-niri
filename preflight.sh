#!/usr/bin/env bash
# Read-only checklist. Does not install software or modify your computer.
set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
count=0
check() {
  local name="$1"; shift
  if command -v "$name" >/dev/null 2>&1; then
    printf '  [OK]  %-24s %s\n' "$name" "$(command -v "$name")"
  else
    printf '  [!!]  %-24s %s\n' "$name" "missing: $*"
    count=$((count+1))
  fi
}
echo 'Bazzite KDE + Niri: read-only preflight'
echo '----------------------------------------'
if [[ -r /etc/os-release ]] && grep -Eiq '^((ID|NAME|PRETTY_NAME)=).*bazzite' /etc/os-release; then
  echo '[OK]  Bazzite detected'
else
  echo '[NOTE] Bazzite not verified from /etc/os-release; this kit targets Bazzite KDE.'
fi
check rpm-ostree 'required for atomic system packages'
check niri 'install Niri, then reboot'
check noctalia 'install Noctalia, then reboot'
check konsole 'expected to come with Bazzite KDE'
check dolphin 'expected to come with Bazzite KDE'
check kate 'install Kate using a supported method if wanted'
if [[ -x /usr/libexec/xdg-desktop-portal ]] || (command -v rpm >/dev/null 2>&1 && rpm -q xdg-desktop-portal >/dev/null 2>&1); then
  echo '[OK]  XDG Desktop Portal installed'
else
  echo '[!!]  XDG Desktop Portal not found'
  count=$((count+1))
fi
if [[ -x /usr/libexec/xdg-desktop-portal-gtk ]] || (command -v rpm >/dev/null 2>&1 && rpm -q xdg-desktop-portal-gtk >/dev/null 2>&1); then
  echo '[OK]  GTK FileChooser portal installed'
else
  echo '[!!]  GTK FileChooser portal not found'
  count=$((count+1))
fi
check xwayland-satellite 'X11 games need Xwayland Satellite'
if [[ -x /usr/libexec/pam_kwallet_init ]]; then
  echo '[OK]  KWallet PAM helper exists'
else
  echo '[!!]  KWallet PAM helper missing: auto-unlock may not work; review KDE/SDDM PAM packages.'
  count=$((count+1))
fi
if [[ -d /usr/share/wayland-sessions ]]; then
  echo 'Sessions available (Niri may appear after reboot):'
  find /usr/share/wayland-sessions -maxdepth 1 -name '*.desktop' -printf '  %f\n' | sort
fi
if command -v rpm-ostree >/dev/null 2>&1; then
  echo 'Deployment summary:'
  rpm-ostree status || true
fi
printf '\nMissing or unverified items: %s\n' "$count"
echo 'This check does NOT change anything.'
exit 0
