# 🛟 How to go back

**Good news:** KDE Plasma is still installed. Nothing in this kit replaces it.

## Easiest: simply choose Plasma

At your login screen, choose **Plasma** instead of **Niri**. That's all. You don't need to uninstall anything to get back to KDE.

## Restore previous user configuration

During `./install.sh --apply`, the kit creates a timestamped backup of **every project-managed user path** before making changes. Copy the printed **BACKUP** folder path somewhere safe.

First inspect it:

```bash
ls -l ~/.local/state/bazzite-kde-niri/backups/
```

Then, after checking the folder is the right one:

```bash
./restore.sh "$HOME/.local/state/bazzite-kde-niri/backups/REPLACE_WITH_YOUR_BACKUP_FOLDER" --apply
```

This operation moves the **current** project-managed files into a separate `replaced-on-restore/` folder, then restores whatever was present before installation. If a file didn't exist originally, the current one is moved aside and nothing is put in its place.

**Don't blindly run restore twice against an unrelated snapshot.** Read the printed paths first and preserve newer important edits.

## OS rollback is a DIFFERENT thing

`rpm-ostree rollback` changes the **system deployment** after a reboot. It does **not** undo home-directory changes made after the previous boot. You may keep Niri installed but simply use Plasma, or remove only the added RPM layers later after reviewing what else needs them.

If you choose an OSTree rollback, inspect `rpm-ostree status` and `ostree admin status` first. Remember that rolling back system packages can change dependencies for other apps. Never use `rpm-ostree reset` casually just to remove Niri: it may remove **unrelated** layered packages.

## Snapper is not a magic rewind button

A Snapper configuration only protects its configured Btrfs subvolume, and an actual snapshot has to exist. Do not execute `snapper undochange` on an arbitrary range until you know what would be overwritten. Snapshot recovery is optional to this project and **not automated**.

## Worst case: Niri won't log in

Use the SDDM session picker to choose **Plasma**, then restore the Niri user config. If even SDDM does not start, use Bazzite's official bootloader/rollback documentation and your verified pinned deployment, rather than commands from an unrelated distribution.
