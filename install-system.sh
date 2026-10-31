#!/usr/bin/env bash
# System package layering is a separate, explicit, reboot-required step.
# Usage: ./install-system.sh                  (read-only explanation)
#        ./install-system.sh --apply          (stage RPM packages after confirmation)
set -euo pipefail
packages=(niri noctalia xwayland-satellite xdg-desktop-portal-gtk xdg-desktop-portal-gnome)
if [[ "${1:-}" != '--apply' ]]; then
  cat <<'TEXT'
SYSTEM PACKAGES (only on Bazzite KDE):
  Niri compositor and SDDM session
  Noctalia v5 shell
  Xwayland Satellite for X11 games
  GTK file chooser and GNOME screencast portals

We use Bazzite's rpm-ostree for system components, NOT pacman or host dnf.
This helper does nothing without --apply. After layering, reboot.
Before applying: inspect rpm-ostree status, ensure a recovery deployment is pinned,
and confirm each package is available on your Bazzite version.
For a missing package: STOP. Do not automatically add third-party COPRs.
TEXT
  printf 'Proposed command: rpm-ostree install'; printf ' %s' "${packages[@]}"; printf '\n'
  exit 0
fi
if [[ $# -ne 1 ]]; then echo 'Usage: install-system.sh [--apply]' >&2; exit 2; fi
if ! command -v rpm-ostree >/dev/null 2>&1; then echo 'This machine lacks rpm-ostree.' >&2; exit 1; fi
if ! grep -Eiq '^((ID|NAME|PRETTY_NAME)=).*bazzite' /etc/os-release; then echo 'Refusing: Bazzite not detected.' >&2; exit 1; fi
if ! command -v konsole >/dev/null 2>&1; then echo 'Refusing: KDE Konsole missing. Use Bazzite KDE image.' >&2; exit 1; fi
echo 'About to stage system-level packages: '
printf '  %s\n' "${packages[@]}"
echo 'This can alter your next Bazzite deployment and requires a reboot.'
echo 'It does not uninstall Plasma, modify Steam, or enable third-party repositories.'
read -r -p 'Type LAYER to continue, anything else to abort: ' answer
if [[ "$answer" != 'LAYER' ]]; then echo 'Cancelled.'; exit 1; fi
rpm-ostree install "${packages[@]}"
echo 'Layering staged. Reboot after checking the command succeeded. Then run ./preflight.sh and ./install.sh --apply.'
