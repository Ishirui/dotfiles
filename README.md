# dotfiles
Hi ! This is my dotfiles repository, which contains configuration files for various applications and tools that I use on a daily basis.

This includes standard things like shell configs, editor configs etc. but also more specific things like my KDE Plasma configuration, which is a bit more involved to set up.

This repo is also a valid Ansible configuration for easily setting up my new machines as I like them :)

There are two layers to the setup:
- **Ansible** (roles + `local.yml`) installs packages and does system-level setup (partitions, btrfs, etc.). It also installs chezmoi and applies the user configs once.
- **chezmoi** (source state in `home/`) owns the day-to-day user configs: fish + starship, zed, obsidian, opencode, Konsole/Yakuake and the XDG user dirs.

Hopefully this inspires you in creating your own stuff !

## Directories
- `roles`: Ansible roles for setting up new machines. Also contains some support files that I don´t consider to be "configs" but are still part of the setup, like configurations referencing machine-specific things, desktop files etc.
- `home`: chezmoi source state — the user configs it manages: fish (shell completions, functions, starship), zed, obsidian (per-vault `.obsidian/`: app settings, the custom `Catppunite Encore` theme and all plugin settings), opencode (config + shared `AGENTS.md`), Konsole/Yakuake and the XDG user dirs. Host-specific values (starship themes per machine) come from `home/.chezmoidata.toml`, and `home/.chezmoiignore` keeps the Linux-only entries off macOS.
- `kde`: the rest of the KDE Plasma configuration — keybinds, window rules, Klassy theming, `.desktop` files (still deployed by Ansible; not in chezmoi yet)
- `scripts`: Various scripts that I use for util purposes.

> *NOTE:* Some config files are not stored in the repo as whole files. KDE files like `kwinrc`, `kdeglobals` and `kcminputrc` mix my settings with state that Plasma rewrites on its own, so the playbook only sets the individual keys it cares about (`community.general.kdeconfig` in `roles/base/tasks/17-kde.yml`) and leaves the rest of the file alone. The one genuinely machine-specific file is the display layout, `roles/desktop/files/kwinoutputconfig.json`, which is why it lives in the desktop role rather than in `home/`.

## Day-to-day config workflow (chezmoi)

Ansible writes a chezmoi config pointing at this repo's `home/` directory, so all chezmoi commands work from anywhere:

- Redeploy configs after a change, without re-running the playbook: `chezmoi apply`
- Preview what would change: `chezmoi diff`
- See which deployed files have drifted from the repo: `chezmoi status`
- After an app edits its own config (zed settings, obsidian...), sync the change back to the repo: `chezmoi re-add <file>` (or `chezmoi add <file>` for new files), then commit and push.
- Render the starship config for this host: `chezmoi cat ~/.config/fish/starship.toml`

# TODO

fix: obsidian theme not applying properly inside blockquotes while in preview edits mode. Works fine in Reading mode
fix: obsidian theme not applying heading color when bold or italic text inside heading (the italics take priority, which is not what I want)



- OpenRGB configuration (desktop)
- Code Editors
- KDE Plasma panels, maybe eww and/or waybar
- Limine and plasma-login-manager things
- Dolphin, Kate, Okular...
- SSH and GPG keys - especially with Git
- Face unlock (package `Howdy` on Arch)
- Sync appearance on other apps: discord, zen, obsidian

- Create windows VM and setup winapps (maybe download a machine image from my server ?)
- Some kind of sandbox or VM for cracked games (esp. lenny)

### Extra packages
- betterbird-bin (AUR)
- zapzap (whatsapp client, AUR)
- freetube-bin (AUR)
- Look into LocalSend (`localsend-bin` AUR)
- yt-dlp
- walker (launcher) (see https://github.com/abenz1267/walker) or vicinae
- webapp-manager (for Monkeytype)

# Hard to do
- Automate the add of second drive to btrfs array - seems dangerous, not hard to do manually. Also need to hide the shortcut from Dolphin which is a lot of annoying XML parsing.


# Consider alternative solutions
- Configure zen browser (login, pinned tabs etc.). Native sync doesn't really support that at the moment, and the config format is not really amenable to ansible (mostly SQL DBs...). We could, I guess, run some SQL queries to prefill the dbs but that seems like a whole lot of work.
> In the meantime, just setup a syncthing folder to get sync working, maybe
- Same for all apps that are not really configurable via config file: vesktop, telegram, 
- For steam, there might be a couple things configurable in ~/.local/share/Steam/config - libraryfolders.vdf in particular, but then again you also have to drop files in the created library so eh.
- Syncthing is configured by XML surgery: `roles/base/tasks/05-syncthing.yml` stops the daemon, deletes and re-adds the `<folder>`/`<device>` nodes with the `xml` module, then restarts it - every playbook run, whether anything changed or not. `syncthingctl` (already installed) and the REST API can declare folders and devices directly, which would be more robust and wouldn't need the daemon stopped. Would work the same whether ansible or something else drives it.

# Laptop stuff to do
- VPN
- TLP
- Different plasma panels
- Optimus-specific things

## Keybinds
### Principle
Desktop related: Meta+arrows
Screen related: Ctrl+Meta+arrows
Changing stuff within a screen/desktop, i.e. within the krohnkite layout: Meta+IJKL
"Move" modifier: Alt

### Results

#### Screens

| Action | Ctrl | Meta | Alt | Shift | Key |
|--------|------|------|-----|-------|-----|
| Switch screens | ✓ | ✓ | | | Arrows |
| Move windows between screens | ✓ | ✓ | ✓ | | Arrows |
| Grid view / overview | ✓ | ✓ | | | Up |

#### Desktops

| Action | Ctrl | Meta | Alt | Shift | Key |
|--------|------|------|-----|-------|-----|
| Switch desktops | | ✓ | | | Arrows |
| Move windows between desktops | | ✓ | ✓ | | Arrows |

#### Krohnkite

| Action | Ctrl | Meta | Alt | Shift | Key |
|--------|------|------|-----|-------|-----|
| Forward layout | | ✓ | | | \ |
| Backward layout | | ✓ | | ✓ | \ (or \|) |
| Change window focus | | ✓ | | | IKJL |
| Move window in layout | | ✓ | ✓ | | IKJL |
| Float window | | ✓ | | | F |
| Float all windows | | ✓ | | ✓ | F |
| Increase layout | | ✓ | | | ] |
| Decrease layout | | ✓ | | ✓ | ] |
| Grow window up/down/left/right | | ✓ | | ✓ | IKJL |
| Toggle docks | | ✓ | | | Return |

> **Note:** Meta+L usually locks the screen - we therefore change it to Meta+Shift+L
