# dotfiles
Hi ! This is my dotfiles repository, which contains configuration files for various applications and tools that I use on a daily basis.

This includes standard things like shell configs, editor configs etc. but also more specific things like my KDE Plasma configuration, which is a bit more involved to set up.

This repo is also a valid Ansible configuration for easily setting up my new machines as I like them :)

Hopefully this inspires you in creating your own stuff !

## Directories
- `roles`: Ansible roles for setting up new machines. Also contains some support files that I don´t consider to be "configs" but are still part of the setup, like configurations referencing machine-specific things, desktop files etc.
- `fish`: Shell completions, functions and my Starship config
- `kde`: KDE Plasma configuration, including panels, desktop, window manager etc.
- `scripts`: Various scripts that I use for util purposes.

> *NOTE:* Some config files (like `kwinrc` for example) are not actually stored in the repo but are generated from templates in the `ansible` directory, since they contain machine-specific information like screen layout, monitor names and might contain some lines I don´t want to include in the repo. The ansible playbook takes care of generating those files and putting them in the right place.

# TODO
- Code Editors
- KDE Plasma panels
- Appearance: color theme, icons, fonts etc.
- Limine and plasma-login-manager things
- Dolphin, Kate, Okular...
- SSH and GPG keys - especially with Git

- Create windows VM and setup winapps (maybe download a machine image from my server ?)

# Hard to do
- Automate the add of second drive to btrfs array - seems dangerous, not hard to do manually. Also need to hide the shortcut from Dolphin which is a lot of annoying XML parsing.


# Consider alternative solutions
- Configure zen browser (login, pinned tabs etc.). Native sync doesn't really support that at the moment, and the config format is not really amenable to ansible (mostly SQL DBs...). We could, I guess, run some SQL queries to prefill the dbs but that seems like a whole lot of work.
> In the meantime, just setup a syncthing folder to get sync working, maybe
- Same for all apps that are not really configurable via config file: vesktop, telegram, 
- For steam, there might be a couple things configurable in ~/.local/share/Steam/config - libraryfolders.vdf in particular, but then again you also have to drop files in the created library so eh.

# Laptop stuff to do
- VPN
- TLP
- Different plasma panels

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
