# 🚀 Publish under the NightBreedLabs GitHub organization

**The ZIP you received is the complete project, not an existing GitHub repository.** The person with permission to create NightBreedLabs repositories needs to publish it once. This guide does not print, copy or store Git credentials.

## Easiest: Create the empty GitHub repository

1. Sign into GitHub in your browser.
2. Open https://github.com/organizations/NightBreedLabs/repositories/new (or the normal **New repository** action under the NightBreedLabs organization).
3. Name it `bazzite-kde-niri`.
4. Set visibility to **Public** so the Linux community can see it. **Confirm you've inspected the ZIP for privacy first.**
5. Don't create a README, license or `.gitignore` in the GitHub form. These are already included in the ZIP.
6. Create the empty repository.

## Put the ZIP files on GitHub

Extract the ZIP to a folder. Open **Konsole** in the folder that contains `README.md` and `install.sh` and run:

```bash
bash tests/test_files.sh
git init -b main
git add .
git status --short
git diff --cached --stat
git commit -m "Initial release: Bazzite KDE + Niri + Noctalia community setup"
git remote add origin git@github.com:NightBreedLabs/bazzite-kde-niri.git
git push -u origin main
```

If Git reports an existing repository or a different `origin`, inspect `git remote -v` and reconcile rather than blindly re-running `git remote add` or force-pushing.

**Alternative using GitHub CLI:** If `gh` is installed and signed in with organization repository-creation rights, `gh repo create NightBreedLabs/bazzite-kde-niri --public --source . --remote origin --push` can create/publish the repo from a prepared local Git checkout instead of using the browser. Do **not** run both workflows.

## What comes after publishing?

- Add screenshots, verified clean-install results, optional clipboard/controllers/VPN modules and a compatibility table over time.
- Request peer reviews for PAM/KWallet, the Niri 26.04 KDL config, GTK/GNOME portal coexistence, Xwayland Satellite gaming, and rollback.
- Consider a release `v0.1.0-preview` rather than claiming the scripts have already been verified on a fresh PC.
- Do **not** include the owner's private NightBreedLabs repo or personal Antigravity/ChatGPT conversations in a public release.
