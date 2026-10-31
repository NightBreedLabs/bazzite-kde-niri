# 🧩 Why all these little fixes exist

## Why Niri next to Plasma?

Niri is a **window compositor**, not a whole KDE replacement. Bazzite KDE already includes many excellent apps. By keeping both desktop sessions in the login menu, we can switch between **KDE's traditional layout** and **Niri's scrollable tiling** without deleting anything.

## Why Konsole, Dolphin, Kate and Breeze?

Because they're already part of the KDE home! The stock CachyOS Niri preset uses its own terminal and cursor setup. We replace those preferences with **Konsole**, **Dolphin**, **Kate**, and **Breeze** to avoid duplicate applications. We don't uninstall unrelated packages automatically.

## Why is the portal file so important?

A portal is like a **reception desk**. Browsers ask it to open file chooser windows. Without the right receptionist, the upload button may do nothing.

Under Niri our file `niri-portals.conf` uses:

```ini
org.freedesktop.impl.portal.FileChooser=gtk;
```

This selects the **GTK file picker**, not the GNOME/Nautilus picker that previously broke under a KDE-centered session. It's not forcing Dolphin out of the system. Bazzite Plasma keeps its own normal portal configuration. File chooser behavior can still vary across browsers and toolkit versions.

Another line is:

```ini
org.freedesktop.impl.portal.Secret=kwallet;
```

This prefers **KWallet for the XDG Secret portal**, but regular Secret Service clients and KDE PAM unlocking need to work too. Setting a line is *not* a password migration. **Don't delete any existing GNOME Keyring or KWallet files.** See [Noctalia Secret Service docs](https://docs.noctalia.dev/noctalia/configuration/secret-service/).

## Why launch the wallet helper?

`/usr/libexec/pam_kwallet_init` helps complete the PAM/login flow after SDDM authenticates you. This only works with suitable PAM configuration, wallet passwords, and available services. We **don't edit `/etc/pam.d`** or launch multiple competing password daemons. If it doesn't unlock, use the [troubleshooting page](TROUBLESHOOT.md).

## Why make dialogs float?

Niri normally puts windows in **columns**. A tiny file picker or FileBot popup looks silly taking an entire column. The window rules ask recognized dialogs to float above other windows. Some dialogs use the parent app's ID and may still be tiled; this depends on the app, not just the rule.

## Why a Java setting?

Some Java Swing/AWT apps, including FileBot, can show gray windows or flickering under Wayland compositors. The Niri-only environment includes:

```text
_JAVA_AWT_WM_NONREPARENTING=1
```

This can help Java compatibility. We don't install FileBot for you or edit any launcher outside this kit; some Java apps may need individual adjustments.

## Why no cliphist, fuzzel or giant plugins by default?

Noctalia v5 already offers a clipboard panel, launcher, bar and screenshot annotation. Adding another clipboard manager, app launcher, or ten background widgets creates more dependencies and failure points. Want an external clipboard tool? **Homebrew provides `cliphist` and `wl-clipboard`**, but `fuzzel` availability depends on the packaging source. Add that optional setup separately and test in your own environment.

## What about your computer's monitor settings?

Every monitor is different. This project **never hardcodes** someone else's screen output, refresh rate, resolution, wallpaper path or home directory. Check `niri msg outputs` after login and tune your own display config if needed.

## Why not install the entire CachyOS preset directly?

Because CachyOS is Arch-based and Bazzite is Fedora Atomic. Their packaging and default applications differ. We use the **modular layout and appearance inspiration**, not CachyOS's system package commands. See [UPSTREAM.md](UPSTREAM.md) for licensing and source details.
