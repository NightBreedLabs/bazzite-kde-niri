# 🎮 Keep the games, add another desktop

**Our rule: the new desktop must not wreck the existing game setup.**

## What's left alone

- Steam library, compatdata, Proton/GE-Proton, gaming prefixes, and launch options.
- Bazzite's kernel, AMD/Intel/NVIDIA drivers, Mesa, gamescope, Steam Game Mode (if you have a compatible image), VRR and game controllers.
- MangoHud and other tools you've already configured.
- Any previous game-specific mods or Wine configuration.

We **do not** set global experimental `RADV_PERFTEST`, Mesa threading, DLL overrides or Proton flags. Such changes can help one game and hurt another. Always benchmark separately.

## Why Xwayland Satellite?

Some games still speak **X11**. Niri is Wayland-native, so it uses **Xwayland Satellite** to display X11 apps and games. Newer Niri integrates it automatically when installed; **do not manually start an extra instance or set DISPLAY by hand**.

Read: https://niri-wm.github.io/niri/Integrating-niri.html

## Easy test drive

1. Start a simple game under **Plasma** and note how it behaves.
2. Log out, choose **Niri** and launch the same game from Steam.
3. Check controller input, fullscreen/floating windows, audio, frames, mouse capture and overlays.
4. If something is worse, test **Plasma again** and compare. Switch back to Plasma for the game until you've investigated.
5. Use `./doctor.sh` for missing base components, but remember that it can't benchmark a game.

### Helpful shortcuts

- `Super + F`: maximize a Niri column.
- `Super + T`: toggle floating on a window.
- `Super + Escape`: release/re-enable a game's shortcut inhibition if the game grabs your keys.

### Steam Deck / Bazzite-Deck?

This guide targets regular **Bazzite KDE desktop** first. Bazzite-Deck has **Gaming Mode** and a different boot/session flow. Don't change it using desktop-only steps without a specific test on the handheld or HTPC.

## Optional controller battery monitoring

The system's Bluetooth/UPower interfaces vary across controller models. The Xbox Series X, Steam Controller and DualSense may report battery differently depending on receiver, firmware and driver. Use `bluetoothctl devices Connected` and `upower -e` to inspect devices (if those tools are installed). A battery widget is **not** bundled or promised by this minimal installer.
