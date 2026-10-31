# Bazzite KDE + Niri + Noctalia 🎮

**Two desktops. One Bazzite installation. Keep your games.**

A community-ready, **CachyOS-inspired** Niri + Noctalia configuration that lives **beside** KDE Plasma on Bazzite. It reuses **Konsole, Dolphin, Kate and KDE Wallet**, and includes the hard-won browser/file-picker and Java dialog fixes.

> 🧪 **Early community preview, 0.1.0**. The files and shell syntax have been checked, but **this complete kit has not yet been tested on a clean Bazzite KDE installation**. Test in a spare system or fresh user account first, not on your only working machine. Niri 26.04+ and Noctalia 5+ are the starting target. Fedora/Bazzite packages and the applications will change over time.
>
> **Not an official Bazzite, CachyOS, Niri or Noctalia project.** No AI assistants, MCP, private accounts or personal data included.

## Imagine two rooms 🚪

- **Room 1: KDE Plasma.** Your existing desktop. Nothing removes it.
- **Room 2: Niri.** A different way of placing windows. Noctalia supplies its bar, launcher and wallpaper.
- **The hallway: the login screen.** Pick **Plasma** or **Niri** before signing in.
- **The toy box: Steam and Bazzite gaming.** It stays where it is. We don't replace the GPU stack, gamescope, Steam, controllers or Bazzite Gaming Mode.

> Screenshots and a clean-machine demo will be added after real-world testing.

**Steam menus flash and close in Niri?** See the
[Steam dropdown menu workaround](docs/STEAM-MENUS.md) for the xwayland-satellite
0.8.3 fix, setup, verification status and rollback.

## Start here, tiny steps

1. **Install Bazzite KDE** from its official site and sign into Plasma once.
2. Open **Konsole** and follow **[START HERE: step-by-step](docs/START-HERE.md)**.
3. Make a backup and check system packages. Bazzite needs a reboot after layering Niri and Noctalia.
4. Preview the desktop changes: `./install.sh --dry-run`.
5. Apply only when ready: `./install.sh --apply`.
6. Log out and choose **Niri**. If it isn't behaving, choose **Plasma** again. Backups are described in **[ROLLBACK.md](docs/ROLLBACK.md)**.

## What you get

| Feature | What it means |
| --- | --- |
| Plasma stays available | SDDM offers two sessions, and this project does not remove KDE. |
| CachyOS-inspired Niri | Modular KDL with gaps, soft corners and smooth scrolling. |
| KDE programs | Super+Enter opens **Konsole**, Super+E opens **Dolphin**, Super+Shift+E opens **Kate**. |
| KDE Wallet | Niri prefers KWallet for the Secret portal, with an optional PAM helper; test real unlock. |
| Browser file pickers | Niri prefers the GTK FileChooser portal to avoid the GNOME/Nautilus picker failure. |
| FileBot / Java | Dialog rules and Java non-reparenting environment setting; no FileBot install required. |
| Noctalia | Bar, launcher, wallpaper and control center. No account-specific plugins enabled. |
| Games | Xwayland Satellite for X11 games. No dangerous Mesa or Steam override tweaks. |
| Recovery | Back up before applying, keep a Plasma fallback, and restore user settings. |

## Super key shortcuts

| Press | Happens |
| --- | --- |
| **Super + Enter** | Konsole |
| **Super + E** | Dolphin |
| **Super + Shift + E** | Kate |
| **Super + Ctrl + Enter** | Noctalia app launcher |
| **Super + S** | Control center |
| **Super + Shift + S** | Noctalia settings |
| **Super + V** | Noctalia clipboard history |
| **Super + Shift + Q** | Logout/power menu |
| **Super + Shift + Escape** | Key shortcut cheat sheet |
| **Ctrl + Alt + Delete** | Leave Niri (returns to login screen) |

## What's in the box?

```text
bazzite-kde-niri/
├── README.md                 ← hello, you're here
├── docs/
│   ├── START-HERE.md         ← easy steps to install
│   ├── HOW-IT-WORKS.md       ← the why behind the weird fixes
│   ├── GAMING.md             ← Steam, gamepads, X11 games and safety
│   ├── ROLLBACK.md           ← how to undo
│   ├── TROUBLESHOOT.md       ← fix browser, wallet and session issues
│   └── UPSTREAM.md           ← CachyOS credits and source
├── config/
│   ├── niri/                 ← clean modular Niri settings
│   ├── noctalia/             ← small optional defaults; no accounts
│   └── xdg-desktop-portal/   ← GTK file picker + KWallet preference
├── preflight.sh             ← read-only detective
├── install-system.sh        ← explicit OS package staging (reboot)
├── install.sh               ← backup + user settings installer
├── restore.sh               ← restore saved user settings
├── doctor.sh                ← read-only checks
├── tests/                   ← simple safety tests
├── LICENSE                  ← GPL-3.0
└── LICENSE-NOTICE.md        ← attribution
```

## Important boundaries

This installer **does not**:

- Delete Plasma or change your display manager, PAM authentication files, system services, Steam, gamescope, Mesa, drivers, kernel, Flatpaks or VPN settings.
- Install Arch/CachyOS packages with `pacman` on Bazzite.
- Copy anybody's personal accounts, Google calendar, browser profile, wallpaper locations or machine-specific monitor settings.
- Install AI agents, editor launchers, quotas, MCP bridges or private database files.
- Promise that every browser, controller or game behaves identically across different hardware.

**Want extra things?** Noctalia has its own clipboard, so the starting kit doesn't need fuzzel/cliphist. See [HOW-IT-WORKS.md](docs/HOW-IT-WORKS.md) for why this is easier to maintain.

## Tell us what worked

For bug reports, share **Bazzite version**, **Niri version**, **Noctalia version**, and a **redacted** `./doctor.sh` output. **Never upload passwords, SSH keys, private logs, browser profiles or home-directory dumps.**

## Credits & legal

Built from the experience of getting **KDE Plasma and Niri to share a home on Bazzite**, with an intentionally separate, community-safe set of files.

We studied the official [CachyOS Niri + Noctalia preset](https://github.com/CachyOS/cachyos-niri-noctalia) (GPL-3.0), the [Niri project](https://niri-wm.github.io/niri/), [Noctalia](https://docs.noctalia.dev/noctalia/), and [Bazzite](https://docs.bazzite.gg/). Attribution and lineage: [UPSTREAM.md](docs/UPSTREAM.md). Project licensed under GPL-3.0-only.
