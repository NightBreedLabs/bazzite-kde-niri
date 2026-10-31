# 🧯 Something weird happened? Read this first

| What you see | Check this | Why |
|---|---|---|
| Niri not on login screen | `ls /usr/share/wayland-sessions/` | RPM install may not have applied before reboot. |
| Black Niri session or no bar | `niri validate --config ~/.config/niri/config.kdl`, `command -v noctalia` | Config parse error or Noctalia missing. Choose Plasma to recover. |
| File upload button does nothing | `grep FileChooser ~/.config/xdg-desktop-portal/niri-portals.conf` | The GTK FileChooser preference may be missing; portal services can need a session restart. |
| Duplicate keyrings, repeated logins | KWalletManager, login PAM integration, Noctalia Secret Service docs | The `kwallet` portal line isn't enough to unlock or migrate stored tokens. |
| Cannot see old X11 games | `command -v xwayland-satellite` | Xwayland is necessary for many X11 apps. Don't start duplicate satellites. |
| FileBot shows blank gray popup | Check `_JAVA_AWT_WM_NONREPARENTING=1` and dialog rules | Java window manager compatibility is app-specific. |
| Screen sharing fails | Check `xdg-desktop-portal-gnome` and session portals | GTK FileChooser and screencasting have different portal backends. |
| Hotkey doesn't work | `grep Mod+ ~/.config/niri/cfg/shortcuts.kdl` | Conflict, a mistyped command or old Niri version. |
| Forgot where backup went | `cat ~/.local/state/bazzite-kde-niri/last-backup` | The settings installer records the exact path. |
| Games worse in Niri | Compare same game in Plasma | Might be game-specific fullscreen/X11/overlay behavior; don't apply global GPU hacks. |

### Harmless read-only commands

```bash
rpm-ostree status
ls /usr/share/wayland-sessions/
command -v niri noctalia konsole dolphin xwayland-satellite
niri validate --config ~/.config/niri/config.kdl
cat ~/.config/xdg-desktop-portal/niri-portals.conf
./doctor.sh
```

These commands inspect configuration. Don't paste wallet contents, private logs, browser tokens, full home paths or passwords into public issues.

### When to ask for help

Include the operating system release, Niri and Noctalia versions and **redacted** error text. Don't copy an entire personal home directory or `journalctl` output without reviewing it first.
