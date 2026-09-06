# Workstation toolset

> **Arch workstation setup.** This catalogue describes the applications
> provisioned by this repo on the Linux machines (CachyOS/Arch + KDE Plasma).
> The group files carry no `brew` sections yet, so application installation on
> macOS remains manual and is not covered here.

Each section below is one metapac group, declared in
`home/dot_config/metapac/groups/<name>.toml`. A group doubles as a role: it is
both the category a package sits in and the capability a machine opts into.
Which machine takes which group is in `home/dot_config/metapac/config.toml.tmpl`.

A `-gui` suffix marks a group that needs a display, so the generic `vm` row is
exactly the set of groups without one.

Dolphin and Konsole come with the CachyOS desktop baseline (KDE defaults) rather
than being declared, and the entries marked "via CachyOS metapackage" are pulled
in by `cachyos-gaming-meta` / `cachyos-gaming-applications`. Everything else is
an explicit declaration in a group file.

## Usage examples

- `Alt+Space` — open/close Vicinae. KRunner stays installed but no longer owns the launcher binding.
- `pack src bundle.zip` expands to `ouch compress src bundle.zip`; `unpack bundle.zip --dir extracted` expands to `ouch decompress bundle.zip --dir extracted`.
- `Ctrl+G` in Fish — navi's cheat-sheet widget over the managed cheat sheets.
- `navi --tldr tar --print` — TLDR lookups through navi's tealdeer integration.
- `help tar` — unchanged: still the `tldr` abbreviation.

---

# Headless-safe groups

These need no display, and make up the `vm` row.

## shell

| Tool | Purpose |
|---|---|
| Fish | Login/interactive shell; configuration in chezmoi `home/` |
| Starship | Prompt, rendered per-machine from chezmoi data |
| fzf | Fuzzy finder for history, files, pipes |
| zoxide | Smarter `cd` with frecency |
| tealdeer (`tldr`) | Fast TLDR client; the `help` abbreviation |
| navi | Interactive cheat sheets, `Ctrl+G` widget |
| tmux | Terminal multiplexer |

## files

| Tool | Purpose |
|---|---|
| eza | Modern `ls` |
| bat | Modern `cat` |
| moor | Modern `less` pager |
| fd | Modern `find`; `fdg` abbreviation for glob mode |
| ripgrep (`rg`) | Fast content search |
| tree | Directory trees |
| Superfile (`spf`) | TUI file manager |
| ouch | Compression/decompression via `pack`/`unpack` |
| unzip | Archive extraction |

## data

| Tool | Purpose |
|---|---|
| jq | JSON processing |
| jless | Interactive JSON pager |
| VisiData (`vd`) | TUI tabular data explorer |

## monitoring

| Tool | Purpose |
|---|---|
| btop | System monitor, the `htop` replacement |
| Fastfetch | System info in terminals |

## network

| Tool | Purpose |
|---|---|
| Nmap (`nmap`) | Network scanning |
| Trippy (`trip`) | TUI traceroute/network diagnostics |
| Wireshark | Packet capture/analysis; `tshark` is the half that matters on a VM |
| WireGuard tools | VPN config (`wg`, `wg-quick`) |

## credentials

| Tool | Purpose |
|---|---|
| GnuPG | Encryption/signing |

## editors-cli

| Tool | Purpose |
|---|---|
| Neovim | Terminal editor |
| micro | Terminal editor, the `nano` replacement |

## dev-tools

| Tool | Purpose |
|---|---|
| Git | Version control; also installed during bootstrap |
| lazygit | TUI for Git |
| OpenCode | Terminal AI coding agent |
| chezmoi | Deploys the user configs; also installed during bootstrap |
| metapac | Installs the packages in this catalogue; manages itself |

Language servers for Zed, OpenCode and CLI use are still unpicked — the
candidate list is a comment in the group file.

## languages

| Tool | Purpose |
|---|---|
| Python | Runtime |
| Node.js | Runtime |
| Go | Runtime |
| Rust | Toolchain via rustup |
| Java | JDK (jdk-openjdk) |
| Deno | Runtime |
| Yarn | Node package manager |
| uv | Python project/tool manager |

## containers

| Tool | Purpose |
|---|---|
| Docker | The container engine; group membership unchanged |

## container-tools

| Tool | Purpose |
|---|---|
| lazydocker | TUI for Docker; talks to the API, so it drives a remote `DOCKER_HOST` with no local engine |

## transfers

| Tool | Purpose |
|---|---|
| rsync | File transfer/sync |
| curl | HTTP transfers; also installed during bootstrap |
| wget | HTTP transfers |
| aria2 | Multi-protocol downloader |

---

# Display-requiring groups

## editors-gui

| Tool | Purpose |
|---|---|
| Zed | Main editor; settings/keymap/theme deployed by chezmoi |
| Cursor | AI-oriented editor |

## dev-tools-gui

| Tool | Purpose |
|---|---|
| Meld | Diff/merge tool |
| Bruno | API client, Postman alternative |
| DevToys | Offline developer utilities toolbox |

## browsers

| Tool | Purpose |
|---|---|
| Zen Browser | Main browser |
| Chromium | Second browser |

Firefox is actively uninstalled — see `roles/base/vars/packages.yml`.

## virtualization

| Tool | Purpose |
|---|---|
| virt-manager | libvirt VM management |

## comms

| Tool | Purpose |
|---|---|
| Vesktop | Discord client |
| Telegram Desktop | Messaging |
| Zoom | Video calls |

## notes

| Tool | Purpose |
|---|---|
| Obsidian | Notes; per-vault config and plugins via chezmoi |

## office

| Tool | Purpose |
|---|---|
| OnlyOffice | Office suite |

## sync

| Tool | Purpose |
|---|---|
| Syncthing | Continuous file sync; folders/devices declared in the playbook |
| SyncthingTray | Tray integration, plus `syncthingctl` and `syncthing-resolve-conflicts` helpers |
| LocalSend | Local network file transfers between devices |
| qBittorrent | Torrent client |

## media-playback

| Tool | Purpose |
|---|---|
| VLC | General media player |
| mpv | Minimal media player |
| Haruna | mpv front-end on Plasma |
| Feishin | Music streaming client (Jellyfin/Navidrome) |
| Fladder | Audiobook player (Audiobookshelf) |

## media-creation

| Tool | Purpose |
|---|---|
| Audacity | Audio editing |
| Kdenlive | Video editing |
| FFmpeg (`ffmpeg`) | Media conversion toolbox |
| HandBrake | Video transcoding |
| KolourPaint | Quick image editing |
| GIMP | Image editing |
| OBS Studio | Screen recording/streaming |
| EasyEffects | PipeWire effects (EQ, filters) per-app |
| Helvum | PipeWire patch panel |

## gaming

| Tool | Purpose |
|---|---|
| Steam | Games, with Proton compatibility |
| Lutris | Open-source game launcher |
| Heroic | GOG/Epic launcher (via CachyOS metapackage) |
| Prism Launcher | Minecraft launcher |
| ProtonUp-Qt | Proton version manager |
| Wine | Windows compatibility, CachyOS-optimized build |
| Winetricks | Wine helper scripts |
| Proton-GE | Community Proton build |
| Protontricks | Winetricks for Steam Proton games (via CachyOS metapackage) |
| Gamescope | Micro-compositor for games |
| GOverlay | MangoHud/GameScope configurator |
| MangoHud | In-game overlay (via CachyOS metapackage) |
| Sunshine | Game streaming host (Moonlight) |

## gaming-mods

| Tool | Purpose |
|---|---|
| r2modman | Thunderstore mod manager |
| Modrinth App | Minecraft mod manager |
| Vortex | Nexus mod manager |
| CKAN | Kerbal Space Program mod manager |
| PDX-Unlimiter | Paradox savegame editor |
| Ludusavi | Game save backup/restore |
| GX52 | Saitek X52 HOTAS driver/configurator |

## desktop

| Tool | Purpose |
|---|---|
| Yakuake | Drop-down terminal, toggled with F12 |
| Vicinae | Launcher and command palette, toggled with `Alt+Space` |
| Filelight | Disk usage visualisation |
| KDE Partition Manager | Partitioning |
| KRename | Batch file renaming |
| Krokiet | Bulk file cleanup and organization |
| Bitwarden | Password manager |
| Flatpak | Sandboxed app runtime |

## kde

| Tool | Purpose |
|---|---|
| PlasmaZones | Tiling window management (krohnkite's replacement) |
| Klassy | Window decorations/titlebars |
| KWin Glass | KWin translucency/glass effect |
| Thermal Monitor | Temperature sensors plasmoid |
| Blurred Wallpaper | Wallpaper blurring plasmoid |
| Wallpaper Engine | Steam Wallpaper Engine integration |
| Event Calendar | Calendar/plasmoid with agenda |
| Arch Update Notifier | Update availability plasmoid |
| Panel Colorizer | Panel theming plasmoid |
| Catppuccin | Plasma color schemes (Macchiato/Mocha) |
| Monaspace Nerd Font | Terminal/UI font |
| chezmoi_modify_manager | Merges the declared KDE INI settings into the live files |

## backups

| Tool | Purpose |
|---|---|
| btrbk | btrfs snapshotting; config and timer owned by the playbook |
| Btrfs Assistant | Snapshot/subvolume management GUI |

## workstation

Not in the `vm` rows: packages every physical machine wants, mirroring the
workstation Ansible role.

| Tool | Purpose |
|---|---|
| Kamoso | Webcam app — both machines have webcams |
| CUPS | Driverless printing (IPP), for the day a printer exists |
| Print Manager | KDE print queue/settings UI |

---

# Per-machine groups

`machines/<host>.toml` holds packages nobody else wants. A file exists only once
a machine actually has some.

## machines/cuboid

| Tool | Purpose |
|---|---|
| CoolerControl | Fan/pump control, deployed with its config |
| liquidctl | Liquid cooler driver |
| it87-dkms | Out-of-tree module for this motherboard's IT87xx monitoring chip |

## machines/vertex

The Legion laptop's hardware stack; the system-level half (PAM, services) is
owned by the laptop Ansible role.

| Tool | Purpose |
|---|---|
| nvidia-open-dkms | RTX 4060 Max-Q driver — the flavor chwd autoconfigures |
| nvidia-utils / lib32 | Driver userspace |
| nvidia-settings | Driver settings GUI |
| nvidia-prime | `prime-run` wrapper for PRIME render offload |
| switcheroo-control | D-Bus API behind Plasma's "run on dGPU" checkbox |
| nvidia-powerd | Dynamic Boost between CPU and dGPU; service enabled by the laptop role |
| mesa-utils | `glxinfo`/`eglinfo` to verify offload |
| nvtop | TUI GPU monitor (both GPUs) |
| amdgpu_top | iGPU monitor |
| LenovoLegionLinux (dkms) | EC driver: fan curves, power modes, conservation mode, hybrid mode; ships legion_cli/legion_gui/legiond |
| lm_sensors | Sensor readings (the LLL module exposes fans/temps through it) |
| TLP | Power management; config chezmoi-managed, symlinked from `/etc/tlp.conf` |
| powertop | Power diagnostics |
| fprintd + Goodix TOD | Fingerprint reader driver (PAM integration owned by the laptop role) |
| pam-fprint-grosshack | PAM wrapper so a failed scan falls back to the password prompt |
| fwupd | Lenovo BIOS/firmware updates via LVFS |
| bluez-obex | Bluetooth file receive (receiving is still buggy — TODO) |

---

# Vicinae launcher extensions

Prebuilt store bundles, deployed as chezmoi externals (weekly refresh via
`chezmoi apply`) and loaded automatically at startup. Not packages, so they are
not part of any group.

| Extension | Integration |
|---|---|
| Arch Packages | Read-only official/AUR package search; no account or preferences |
| Systemd | System/user services and logs; actions use normal authorization |
| SSH | Host discovery from `~/.ssh/config` (does not follow `Include` directives) |
| Bluetooth | Adapters/devices through BlueZ; no pairing or radio automation |
| Process Manager | Interactive process inspection; the bulk-kill entrypoint is disabled |

KDE settings modules (`kcm_*`) are searchable through Vicinae's built-in
Plasma settings provider.
