# TODO
- Shell profile (default is already pretty good, but I'd maybe want a couple more things, e.g aliases, link nano to micro and cat to bat and zeditor to zed)
- Setup syncthing
- Code Editors
- KDE Plasma panels
- Appearance: color theme, icons, fonts etc.
- Limine and plasma-login-manager things
- Dolphin, Yakuake, Kate, Okular...
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
Switch screens: Ctrl + Meta + Arrows
Move windows between screens: Ctrl + Meta + Alt + Arrows

Grid view / overview : Ctrl + Meta + Up

#### Dekstops
Switch desktops: Meta + Arrows
Move windows between desktops: Meta + Alt + Arrows

#### Krohnkite
Forward layout: Meta + \
Backward layout: Meta + Shift + \ = Meta + |
Change window focus: Meta + IKJL
> Note: Meta+L usually locks the screen - we therefore change it to Meta+Shift+L
Move window in layout = Meta + Alt + IKJL
Float window: Meta + F
Float all windows: Meta + Shift + F
Increase layout: Meta + ]
Decrease layout: Meta + Shift + ]
Grow window up/down/left/right: Meta + Shift + IKJL
Toggle docks: Meta + Return
