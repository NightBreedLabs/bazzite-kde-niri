# Steam dropdown menus close immediately in Niri

If Steam's **Steam, View, Friends, Games or Help** menus flash and disappear,
check xwayland-satellite before changing Steam or graphics settings. Our
October 30, 2026 diagnosis used Niri 26.04 with Fedora's
`xwayland-satellite-0.8.2-1.fc44`. The symptoms matched
[upstream report #489](https://github.com/Supreeeme/xwayland-satellite/issues/489).

[xwayland-satellite v0.8.3](https://github.com/Supreeeme/xwayland-satellite/releases/tag/v0.8.3)
includes the Steam popup fix, commit
[`add2795`](https://github.com/Supreeeme/xwayland-satellite/commit/add2795).
We built that release and selected it with Niri's supported binary override.

**Verification status:** the build, all 84 upstream library tests, host library
checks, an isolated X11 startup/query and Niri configuration validation passed.
At documentation time, activation and visual Steam menu verification after a
normal Niri logout/login were still pending. This is a documented workaround
with completed build checks, not a confirmed end-to-end result on a fresh install.

## Prefer the system package when it contains the fix

Inspect the installed versions:

```bash
niri --version
rpm -q xwayland-satellite
/usr/bin/xwayland-satellite -version
```

Check your distribution's package changelog for v0.8.3 or a backport of the popup
fix. If available, use Bazzite's normal update process, reboot as required and
test Steam again. Package availability changes; the original 0.8.2 observation
is dated. Skip the custom build if the packaged version already fixes the issue.

## Optional user-local build when the package lags

This is an advanced, manual workaround; the kit's installer does not apply it.
Keep the packaged binary installed. Our original build used a temporary rootless
Fedora 44 container, leaving host RPMs and the existing toolbox unchanged.

The recipe below requires Git and rootless Podman on the host, downloads upstream
source and build dependencies, and uses a Fedora release matching the host's
Fedora base. The example is for Fedora 44. Check `cat /etc/os-release` first;
building against a newer base can produce a binary that cannot run on your host.
The upstream source requires Rust 1.85 or later. Its runtime needs Xwayland
23.1 or later, libxcb and xcb-util-cursor; retain the system satellite package
and its dependencies.

Run these commands in **Bash on the host**. Stop if any command fails:

```bash
(
set -euo pipefail
mkdir -p "$HOME/.cache"
steam_fix_src=$(mktemp -d "$HOME/.cache/steam-satellite-build.XXXXXX")
git clone --branch v0.8.3 --depth 1 \
    https://github.com/Supreeeme/xwayland-satellite.git "$steam_fix_src/source"
test "$(git -C "$steam_fix_src/source" rev-parse HEAD)" = \
    b83eab900644e4c7c77982ce3d44cb490f0c5e1d

# Dependencies are installed inside this disposable container, not on Bazzite.
podman run --rm \
    -v "$steam_fix_src/source:/src:Z" -w /src \
    registry.fedoraproject.org/fedora:44 bash -euc '
        dnf -y install cargo clang gcc git pkgconf-pkg-config \
            libxcb-devel xcb-util-cursor-devel wayland-devel
        cargo build --release --locked --features systemd --jobs 4
        cargo test --locked --features systemd --lib --jobs 4
    '

steam_fix_bin="$HOME/.local/opt/xwayland-satellite/0.8.3/bin/xwayland-satellite"
# Preserve an existing build rather than overwriting it.
test ! -e "$steam_fix_bin"
install -Dm755 "$steam_fix_src/source/target/release/xwayland-satellite" "$steam_fix_bin"
printf 'Build source retained at: %s\n' "$steam_fix_src/source"
ldd "$steam_fix_bin"
"$steam_fix_bin" -version
"$steam_fix_bin" --test-listenfd-support
)
```

Before continuing, confirm that the host `ldd` output has **no missing libraries**,
the version reports `v0.8.3`, and the listen-fd check exits successfully. If the
loader reports incompatible libraries or a missing GLIBC version, stop and use a
compatible build environment. Do not replace host libraries to accommodate it.
The source checkout remains in the printed cache directory for inspection.
This recipe follows the recorded build's dependencies and Cargo flags; it is
not a byte-for-byte reproducible binary or a clean-machine installation test.

## Back up and select the binary in Niri

Back up the entire current Niri configuration before editing:

```bash
steam_fix_backup="$HOME/.local/state/steam-menu-fix/$(date -u +%Y%m%dT%H%M%S%NZ)"
mkdir -p "$steam_fix_backup"
cp -a "$HOME/.config/niri" "$steam_fix_backup/niri"
printf 'Backup: %s\n' "$steam_fix_backup/niri"
printf 'Binary path for KDL: %s\n' \
    "$HOME/.local/opt/xwayland-satellite/0.8.3/bin/xwayland-satellite"
```

Open `~/.config/niri/config.kdl`. Add this **top-level** block, replacing the
example path with the full binary path printed above. If an
`xwayland-satellite` block already exists in your config or included files,
edit its `path` instead of adding a second block. Preserve other settings.

```kdl
// Steam popup workaround; restart the Niri session to activate.
xwayland-satellite {
    path "/absolute/path/to/.local/opt/xwayland-satellite/0.8.3/bin/xwayland-satellite"
}
```

Validate before logging out:

```bash
niri validate --config "$HOME/.config/niri/config.kdl"
```

If validation fails, correct the edit or restore the edited file from your new
backup before proceeding. See Niri's
[xwayland-satellite configuration reference](https://niri-wm.github.io/niri/Configuration:-Miscellaneous.html#xwayland-satellite).

## Activate and verify

1. Save your work and **log out of Niri normally, then log back into Niri**.
   A config reload does not replace the already running satellite. Do not kill
   it in the active session: that disconnects its X11 applications.
2. Open Steam, then run `ps -C xwayland-satellite -o pid,args`. Confirm the
   running command uses the user-local `0.8.3` binary. Niri starts it on demand,
   so it may be absent until an X11 application opens.
3. Try **Steam, View, Friends, Games, Help**, a nested submenu and Friends
   context menus. Confirm they stay open and accept clicks.
4. Launch an X11 game and check fullscreen, input and overlays. If the symptom
   remains, record the versions and report it rather than assuming every Steam
   menu failure has the same cause. Plasma remains available as a fallback.

Let Niri manage satellite. Do not add a second startup command, enable a separate
satellite service or force `DISPLAY`. This workaround does not require changes
to focus-follows-mouse, Steam files, Proton, Mesa or GPU settings.

## Undo, and return to distribution updates

Back up your **current** Niri configuration again to preserve subsequent edits.
Remove only the workaround's `path` entry and comment; remove the block too if
you added it solely for this fix. If you replaced an existing custom path,
restore its previous value from the backup. Validate, then log out and back in
normally. Without a custom path, Niri uses the system satellite again. Leave the
user-local binary in place until that session has been checked.

Use the same procedure when the distribution package contains the fix. A pinned
user-local path bypasses future packaged satellite updates until removed.
