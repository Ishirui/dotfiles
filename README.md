# dotfiles
Hi ! This is my dotfiles repository, which contains configuration files for various applications and tools that I use on a daily basis.

This includes standard things like shell configs, editor configs etc. but also more specific things like my KDE Plasma configuration, which is a bit more involved to set up.

This repo is also a valid Ansible configuration for easily setting up my new machines as I like them :)

There are three layers to the setup:
- **Ansible** (roles + `local.yml`) does system-level setup (partitions, btrfs, services, display layout) and bootstraps the other two.
- **metapac** (group files in `home/dot_config/metapac/`) owns the package set: what is installed, and which machines get it.
- **chezmoi** (source state in `home/`) owns the day-to-day user configs: fish + starship, zed, obsidian, opencode, Konsole/Yakuake, the XDG user dirs and all of the KDE configs. It also deploys metapac's own group files.

## Desktop setup

The provisioned Linux workstation is:

| Component | Choice |
|---|---|
| Base | CachyOS (Arch Linux) |
| Desktop | KDE Plasma 6 on Wayland |
| Window management | PlasmaZones tiling |
| Shell | Fish + Starship |
| Terminals | Konsole + Yakuake |
| Launcher | Vicinae (`Alt+Space`) |
| Editor | Zed |
| Appearance | Catppuccin themes, Klassy, Monaspace Nerd Font, YAMIS icons, Lavender Plasma theme |

The full application catalogue and day-to-day usage examples (`pack`/`unpack`, `Ctrl+G`, `navi --tldr`, `Alt+Space`) live in [docs/tools.md](docs/tools.md).

Hopefully this inspires you in creating your own stuff !

## Directories
- `roles`: Ansible roles for setting up new machines. Also contains some support files that I don´t consider to be "configs" but are still part of the setup, like configurations referencing machine-specific things, desktop files etc.
- `home/dot_config/metapac`: the package set — `groups/*.toml` declare packages by group, `config.toml.tmpl` maps machines to groups. Deployed by chezmoi like any other config.
- `home`: chezmoi source state — the user configs it manages: fish (shell completions, functions, starship), zed, obsidian (per-vault `.obsidian/`: app settings, the custom `Catppunite Encore` theme and all plugin settings), opencode (config + shared `AGENTS.md`), Konsole/Yakuake, the XDG user dirs, and the KDE configs (keybinds, window rules, Klassy theming, launchers, plus `kwinrc`/`kdeglobals`/`kcminputrc`/`plasmarc` via `chezmoi_modify_manager`). The YAMIS icons and the Lavender Plasma theme are fetched from upstream as externals (`home/.chezmoiexternal.toml.tmpl`), host-specific values (starship themes per machine) come from `home/.chezmoidata.toml`, and `home/.chezmoiignore` keeps the Linux-only entries off macOS.
- `scripts`: Various scripts that I use for util purposes.

> *NOTE:* `kwinrc`, `kdeglobals`, `kcminputrc` and `plasmarc` mix my settings with state that Plasma rewrites on its own, so they are not stored whole: a `modify_` script (`chezmoi_modify_manager`) merges the declared settings into the live file and passes the volatile parts through — see the `home/dot_config/modify_*` scripts. The one genuinely machine-specific file is the display layout, `roles/desktop/files/kwinoutputconfig.json`, which is why it lives in the desktop role rather than in `home/`.

## Packages (metapac)

Packages are declared in `home/dot_config/metapac/groups/`, one TOML file per group, and installed by [metapac](https://github.com/ripytide/metapac). Ansible only installs metapac and runs `metapac sync`.

A group doubles as a role: `gaming`, `dev-tools` and `browsers` are both the category a package sits in and the capability a machine opts into. `home/dot_config/metapac/config.toml.tmpl` then maps each machine to the groups it wants:

| Row | Machine |
|---|---|
| `Cuboid` | Desktop — every group, plus `machines/cuboid` for the fan-control hardware |
| `Vertex` | Laptop — every group |
| `COMP-…` | Work Mac — the terminal toolkit and editors only |
| `vm` | Any headless throwaway box (AWS, Proxmox) |
| `gui-vm` | The same, plus browsers and the GUI editors |

A `-gui` suffix marks a group that needs a display, so `vm` is exactly the set of groups without one. `vm` and `gui-vm` are OS-agnostic: the backend (`arch`/`apt`/`dnf`/`brew`) is derived from the OS, so `metapac --hostname vm sync` provisions a new VM whatever distro it runs. Give it its own row if it turns out to be permanent — an undeclared hostname is a hard error rather than a guess.

- Add or remove a package: edit the group file, then `chezmoi apply ~/.config/metapac && metapac sync`
- See what is installed but not declared: `metapac unmanaged`
- Install just one group set ad hoc: `metapac --hostname vm sync`

> *NOTE:* `metapac clean` (uninstall everything undeclared) is deliberately **not** run by the playbook. It is a system-wide sweep that also recursively removes orphans, which is risky next to CachyOS's metapackages. Packages that must be actively uninstalled are declared in `roles/base/vars/packages.yml` instead, since metapac has no "ensure absent".

## Day-to-day config workflow (chezmoi)

Ansible writes a chezmoi config pointing at this repo's `home/` directory, so all chezmoi commands work from anywhere:

- Redeploy configs after a change, without re-running the playbook: `chezmoi apply`
- Preview what would change: `chezmoi diff`
- See which deployed files have drifted from the repo: `chezmoi status`
- After an app edits its own config (zed settings, obsidian...), sync the change back to the repo: `chezmoi re-add <file>` (or `chezmoi add <file>` for new files), then commit and push.
- KDE INI files (`kwinrc`, `kdeglobals`, ...) are merged, not whole-managed: `chezmoi status` only flags the declared settings, and changes made in Plasma's settings apps are captured back with `chezmoi_modify_manager --add <file>`.
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
Add these to the relevant group file under `home/dot_config/metapac/groups/`:
- betterbird-bin (AUR) — `comms`
- zapzap (whatsapp client, AUR) — `comms`
- freetube-bin (AUR) — `media-playback`
- yt-dlp — `transfers`
- webapp-manager (for Monkeytype) — `desktop`

# Hard to do
- Automate the add of second drive to btrfs array - seems dangerous, not hard to do manually. Also need to hide the shortcut from Dolphin which is a lot of annoying XML parsing.


# Consider alternative solutions
- Configure zen browser (login, pinned tabs etc.). Native sync doesn't really support that at the moment, and the config format is not really amenable to ansible (mostly SQL DBs...). We could, I guess, run some SQL queries to prefill the dbs but that seems like a whole lot of work.
> In the meantime, just setup a syncthing folder to get sync working, maybe
- Same for all apps that are not really configurable via config file: vesktop, telegram, 
- For steam, there might be a couple things configurable in ~/.local/share/Steam/config - libraryfolders.vdf in particular, but then again you also have to drop files in the created library so eh.
- Syncthing is configured by XML surgery: `roles/base/tasks/04-syncthing.yml` stops the daemon, deletes and re-adds the `<folder>`/`<device>` nodes with the `xml` module, then restarts it - every playbook run, whether anything changed or not. `syncthingctl` (already installed) and the REST API can declare folders and devices directly, which would be more robust and wouldn't need the daemon stopped. Would work the same whether ansible or something else drives it.

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

#### Other

| Action | Ctrl | Meta | Alt | Shift | Key |
|--------|------|------|-----|-------|-----|
| Open/close Vicinae | | | ✓ | | Space |
| Toggle HDR | | ✓ | ✓ | | H |

> **Note:** Meta+L usually locks the screen - we therefore change it to Meta+Shift+L

> **Note:** Toggle HDR runs `~/.local/bin/toggle_hdr.sh`, deployed by chezmoi along with its launcher and the binding in `kglobalshortcutsrc`.
