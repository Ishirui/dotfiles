# TODO
- SSH and GPG keys - especially with Git
- Code Editors
- Krohnkite
- Keybinds (omg please give parity with macos)
- Shell profile (default is already pretty good, but I'd maybe want a couple more things, e.g aliases, link nano to micro and cat to bat)
- Setup syncthing
- KDE Plasma panels
- Appearance: color theme, icons, fonts etc.
- Limine and plasma-login-manager things
- Dolphin, Yakuake, Kate, Okular...
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
