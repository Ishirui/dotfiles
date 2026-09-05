# Workstation toolset

> **Arch workstation setup.** This catalogue describes the applications
> provisioned by this repo on the Linux machines (CachyOS/Arch + KDE Plasma).
> The mac role only deploys user configs and a couple of brew packages;
> application installation on macOS remains manual and is not covered here.

Dolphin and Konsole come with the CachyOS desktop baseline (KDE defaults)
rather than being declared in the Ansible roles, and the entries marked
"via CachyOS metapackage" are pulled in by `cachyos-gaming-meta` /
`cachyos-gaming-applications`. Everything else is an explicit package
declaration in the roles.

## Usage examples

- `Alt+Space` — open/close Vicinae. KRunner stays installed but no longer owns the launcher binding.
- `pack src bundle.zip` expands to `ouch compress src bundle.zip`; `unpack bundle.zip --dir extracted` expands to `ouch decompress bundle.zip --dir extracted`.
- `Ctrl+G` in Fish — navi's cheat-sheet widget over the managed cheat sheets.
- `navi --tldr tar --print` — TLDR lookups through navi's tealdeer integration.
- `help tar` — unchanged: still the `tldr` abbreviation.

## Desktop and terminals

| Tool | Purpose |
|---|---|
| Dolphin | File manager (KDE default via CachyOS, not explicitly declared) |
| Konsole | Terminal emulator (KDE default via CachyOS) |
| Yakuake | Drop-down terminal, toggled with F12 |
| Vicinae | Launcher and command palette, toggled with `Alt+Space` |

## Shell and navigation

| Tool | Purpose |
|---|---|
| Fish | Login/interactive shell; configuration in chezmoi `home/` |
| Starship | Prompt, rendered per-machine from chezmoi data |
| fzf | Fuzzy finder for history, files, pipes |
| zoxide | Smarter `cd` with frecency |
| tealdeer (`tldr`) | Fast TLDR client; the `help` abbreviation |
| navi | Interactive cheat sheets, `Ctrl+G` widget |
| tmux | Terminal multiplexer |

## Files, search, archives

| Tool | Purpose |
|---|---|
| eza | Modern `ls` |
| bat | Modern `cat` |
| moor | Modern `less` pager |
| fd | Modern `find`; `fdg` abbreviation for glob mode |
| ripgrep (`rg`) | Fast content search |
| tree | Directory trees |
| Superfile (`spf`) | TUI file manager |
| Filelight | Disk usage visualisation |
| ouch | Compression/decompression via `pack`/`unpack` |
| Krokiet | Bulk file cleanup and organization |
| KRename | Batch file renaming |

## Editors and developer tools

| Tool | Purpose |
|---|---|
| Zed | Main editor; settings/keymap/theme deployed by chezmoi |
| Neovim | Terminal editor |
| Cursor | AI-oriented editor |
| micro | Terminal editor, the `nano` replacement |
| OpenCode | Terminal AI coding agent |
| Git | Version control, installed early in the base role |
| lazygit | TUI for Git |
| Meld | Diff/merge tool |
| Bruno | API client, Postman alternative |
| DevToys | Offline developer utilities toolbox |

## Containers and virtual machines

| Tool | Purpose |
|---|---|
| Docker | Containers; group membership unchanged |
| lazydocker | TUI for Docker |
| virt-manager | libvirt VM management |

## Data exploration

| Tool | Purpose |
|---|---|
| jq | JSON processing |
| jless | Interactive JSON pager |
| VisiData (`vd`) | TUI tabular data explorer |

## Development environments

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

## Browsers and communication

| Tool | Purpose |
|---|---|
| Zen Browser | Main browser |
| Chromium | Second browser |
| Vesktop | Discord client |
| Telegram Desktop | Messaging |
| Zoom | Video calls |

## Notes and office

| Tool | Purpose |
|---|---|
| Obsidian | Notes; per-vault config and plugins via chezmoi |
| OnlyOffice | Office suite |

## Sync, transfers, downloads

| Tool | Purpose |
|---|---|
| Syncthing | Continuous file sync; folders/devices declared in the playbook |
| SyncthingTray | Tray integration, plus `syncthingctl` and `syncthing-resolve-conflicts` helpers |
| LocalSend | Local network file transfers between devices |
| rsync | File transfer/sync |
| curl / wget | HTTP transfers |
| aria2 | Multi-protocol downloader |
| qBittorrent | Torrent client |

## Media playback

| Tool | Purpose |
|---|---|
| VLC | General media player |
| mpv | Minimal media player |
| Haruna | mpv front-end on Plasma |
| Feishin | Music streaming client (Jellyfin/Navidrome) |
| Fladder | Audiobook player (Audiobookshelf) |

## Audio, recording, creation

| Tool | Purpose |
|---|---|
| Audacity | Audio editing |
| Helvum | PipeWire patchbay |
| EasyEffects | PipeWire effects (EQ, filters) per-app |
| OBS Studio | Screen recording/streaming |
| Kdenlive | Video editing |
| FFmpeg (`ffmpeg`) | Media conversion toolbox |
| HandBrake | Video transcoding |
| GIMP | Image editing |
| KolourPaint | Quick image editing |

## Gaming and compatibility

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
| Ludusavi | Game save backup/restore |

## Mods and gaming peripherals

| Tool | Purpose |
|---|---|
| r2modman | Thunderstore mod manager |
| Modrinth App | Minecraft mod manager |
| Vortex | Nexus mod manager |
| CKAN | Kerbal Space Program mod manager |
| PDX-Unlimiter | Paradox savegame editor |
| GX52 | Saitek X52 HOTAS driver/configurator |

## Monitoring, networking, credentials

| Tool | Purpose |
|---|---|
| btop | System monitor, the `htop` replacement |
| Fastfetch | System info in terminals |
| Wireshark | Packet capture/analysis |
| Nmap (`nmap`) | Network scanning |
| Trippy (`trip`) | TUI traceroute/network diagnostics |
| WireGuard tools | VPN config (`wg`, `wg-quick`) |
| Bitwarden | Password manager |
| GnuPG | Encryption/signing |
| CoolerControl | Fan/pump control, deployed with its config |

## KDE appearance and behavior

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
| Catppuccin | Plasma color schemes (Macchiato/Mocha) + app themes |
| Monaspace Nerd Font | Terminal/UI font |

## Vicinae launcher extensions

Prebuilt store bundles, deployed as chezmoi externals (weekly refresh via
`chezmoi apply`) and loaded automatically at startup:

| Extension | Integration |
|---|---|
| Arch Packages | Read-only official/AUR package search; no account or preferences |
| Systemd | System/user services and logs; actions use normal authorization |
| SSH | Host discovery from `~/.ssh/config` (does not follow `Include` directives) |
| Bluetooth | Adapters/devices through BlueZ; no pairing or radio automation |
| Process Manager | Interactive process inspection; the bulk-kill entrypoint is disabled |

KDE settings modules (`kcm_*`) are searchable through Vicinae's built-in
Plasma settings provider.
