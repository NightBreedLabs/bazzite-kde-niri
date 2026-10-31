# 🧸 Start Here: KDE + Niri, step by step

You are not replacing KDE! We are putting a second desktop next to it.

**You need:** a computer with a **fresh Bazzite KDE Plasma installation**, internet, a keyboard, and permission to run `rpm-ostree` system updates. Desktop Bazzite and Bazzite-Deck differ; this guide targets **desktop Bazzite KDE** first.

## Step 0. Make sure KDE works

Boot your PC, log in to **Plasma**, open **Konsole**, and try Steam or another application you care about. You need a known-good starting point.

## Step 1. Make a safety net 🛟

1. In Konsole:

   ```bash
   rpm-ostree status
   sudo ostree admin status
   ```

2. Find which **deployment is booted**. If you want to pin that exact working deployment so the system doesn't prune it, follow Bazzite's OSTree guidance and use `sudo ostree admin pin <index>`, replacing `<index>` with the verified deployment index. **Do not guess the number**.
3. Back up your important files separately. A pinned OS deployment **does not protect your home directory**.
4. Already using Snapper? Check `sudo snapper list-configs` and `sudo snapper -c <configuration> list`. **Do not assume /home is included** or that a snapshot exists.

## Step 2. Put the system pieces in the toy box

Niri and Noctalia are **system components** here, so Bazzite uses `rpm-ostree` to layer them. Do **not** run CachyOS/Arch `pacman` commands on Bazzite, or generic `sudo dnf install` on an atomic host.

Check package availability on your Bazzite version:

```bash
rpm-ostree search niri
rpm-ostree search noctalia
rpm-ostree search xwayland-satellite
rpm-ostree search xdg-desktop-portal-gtk
rpm-ostree search xdg-desktop-portal-gnome
```

**Why these?** Niri puts windows in order. Noctalia draws the shell. Xwayland Satellite lets X11 games/apps show up. GTK handles file selection. The GNOME backend helps screen sharing. **We don't install GNOME Desktop or GNOME Keyring as your default.**

The simple **manual** installation command, after checking your package sources, is:

```bash
rpm-ostree install niri noctalia xwayland-satellite xdg-desktop-portal-gtk xdg-desktop-portal-gnome
```

If you already have a package, rpm-ostree may report it as already provided. Some Bazzite versions may need different package sources; **do not add third-party COPRs just to make the tutorial succeed**. Stop and check the official package docs instead.

If you downloaded the kit, its alternative `./install-system.sh --apply` **asks you to type LAYER** before running exactly that package command. It will not reboot for you.

**Now reboot.** `rpm-ostree` changes the next boot, not your active session. Make sure **Plasma still works** after the reboot.

## Step 3. Open the installation kit

From an extracted ZIP (or cloned repository), change directory to the **project folder**, then:

```bash
./preflight.sh
./install.sh --dry-run
```

**Read the results.** If Niri/Noctalia, Konsole, the GTK portal, or the KWallet PAM helper is missing, fix that first. The configuration installer won't go forward when Niri/Noctalia, Konsole, Dolphin, or the PAM helper are unavailable.

## Step 4. Install the user configuration

The installer **never silently applies changes**. Run:

```bash
./install.sh --apply
```

It validates the included Niri files, backs up your existing Niri and portal settings into `~/.local/state/bazzite-kde-niri/backups/`, copies the clean settings, and prints the backup path. No sudo needed. It **does not touch** your Steam library, your KDE Plasma config, or system PAM files.

If a path is a symlink or an unexpected file type, the installer stops so you can inspect it rather than overwriting someone's dotfile manager.

## Step 5. Pick your room at the login screen

1. Log out of KDE Plasma.
2. Find the **session selector** on the login screen (its position depends on your SDDM theme).
3. Choose **Niri** and log in.
4. Try **Super + Enter** to open Konsole.
5. Try **Super + E** to open Dolphin.
6. Try **Super + Ctrl + Enter** to open Noctalia's launcher.

If Niri fails to start, log out or reboot and select **Plasma** again. The whole idea is that KDE stays your safety net.

## Step 6. Check the important things

From Konsole in Niri:

```bash
./doctor.sh
```

Check manually:

- Browser **Upload / Choose File** dialog opens.
- KDE Wallet asks at most once, and logins persist after logging out/back in (actual behavior depends on SDDM/PAM and password storage).
- An X11 game or Steam overlay displays properly.
- Screen sharing works in your chosen app (GNOME portal backend may be needed).
- Your controller works in Steam; don't blame Niri for Bluetooth firmware behavior without testing Plasma too.

Then log into Plasma and test Steam again.

## Step 7. If you don't like it

You can keep using **Plasma** simply by selecting it at login. To restore your previous user configuration, read **[ROLLBACK.md](ROLLBACK.md)**. You don't have to uninstall Niri to keep using KDE.

## Helpful official pages

- [Bazzite package layering](https://docs.bazzite.gg/Installing_and_Managing_Software/rpm-ostree/)
- [Niri getting started](https://niri-wm.github.io/niri/Getting-Started.html)
- [Noctalia installation](https://docs.noctalia.dev/noctalia/getting-started/installation/)
- [Noctalia running with Niri](https://docs.noctalia.dev/noctalia/getting-started/running-the-shell/)
