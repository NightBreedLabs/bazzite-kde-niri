# Where this configuration comes from

**Goal:** Add a Niri session to a *Bazzite KDE Plasma* installation, using the convenient modular style of the official CachyOS Niri + Noctalia preset but substituting existing KDE software.

- Original CachyOS source: https://github.com/CachyOS/cachyos-niri-noctalia
- Revision **inspected during kit creation**: `6caa9ca656d02bae7390eaa7114229498885a5a5`.
- The original user's exact historical imported CachyOS revision is unknown. We are **not** claiming this package is an official, unmodified CachyOS preset.
- Niri docs: https://niri-wm.github.io/niri/ (includes & syntax).
- Noctalia docs: https://docs.noctalia.dev/noctalia/.
- Bazzite software layering: https://docs.bazzite.gg/Installing_and_Managing_Software/rpm-ostree/.
- Upstream CachyOS package is GPL-3.0-only; respect that license when distributing derivatives.

### What is intentionally different

| Official CachyOS assumptions | This Bazzite KDE edition |
|---|---|
| Arch's `pacman` | Bazzite's `rpm-ostree` for system packages; Homebrew for optional CLI |
| Alacritty | Konsole |
| GNOME Keyring defaults | KDE Wallet preference; requires working Secret Service + PAM login |
| Capitaine cursor | Breeze cursors |
| GNOME file dialog | GTK XDG FileChooser portal, to avoid broken Nautilus/GNOME portal dialogs |
| CachyOS hardware/output preset | No display names, modes, refresh rates, or resolutions hardcoded |
| Niri as an independent desktop | Niri **alongside** intact KDE Plasma session |
| Custom Mesa/Proton overrides | No forced graphics/environment gaming tweaks |
| Predefined account/theme metadata | No Google accounts, emails, private paths, locations, or credentials |

### What is not included

AI agents, browser integrations, shared memory, personal calendar OAuth, wallpapers, Proton VPN wrapper, private keys and account-specific files are not part of this public base. FileBot floating rules are harmless if unused. Additional optional recipes can be developed and tested separately.
