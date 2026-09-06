---
created: 2026-09-05T16:26:51.442Z
source: plannotator
tags: [plannotator, dotfiles, minimal, arch, tooling, fish, toml]
---

[[Plannotator Plans]]

# Minimal Arch Tooling Implementation Plan

**Goal:** Add the 13 selected tools on Arch/KDE, provide useful Fish integrations, make Vicinae the `Alt+Space` launcher, and document the complete workstation toolset in a readable categorized catalogue.

**Architecture:** Ansible installs packages, applies chezmoi after the package phases, and manages the required services. Chezmoi owns shell configuration, upstream cheat sheets, prebuilt Vicinae extensions, selected launcher settings, and KDE shortcuts. The README presents the desktop setup; a separate catalogue documents the full toolset.

**Tech Stack:** Ansible, the existing `kewlfft.aur.aur` package tasks, chezmoi, Fish, KDE Plasma, and systemd user services.

## Scope

- Package installation and desktop integration target Arch/KDE. Leave Homebrew unchanged. Shared Fish abbreviations follow the existing pattern; navi initialization/assets and Vicinae configuration remain Linux-only.
- Install navi, Vicinae, LocalSend, DevToys, ouch, Ludusavi, EasyEffects, Krokiet, KRename, lazydocker, VisiData, jless, and Trippy.
- Vicinae replaces KRunner's `Alt+Space` binding. Leave KRunner and its libraries installed.
- Include the selected native Vicinae extensions: Arch Packages, Systemd, SSH, Bluetooth, and Process Manager. Deploy them automatically without store-installation steps.
- Fully manage navi's stock Fish widget and initial upstream cheat sheets. Enable tealdeer compatibility for explicit `navi --tldr` use; leave `help` and the stock `Ctrl+G` behavior unchanged.
- Add only `pack` and `unpack` to the existing Fish abbreviations.
- No audio presets, backup schedules, game-library definitions, custom-written extensions, or Obsidian integration in this change.
- Preserve Docker permissions, firewall rules, and power-management daemons. The target already uses PipeWire. Rely on the existing CachyOS desktop baseline for SSH, process utilities, and BlueZ.
- Keep histories, identities, caches, application databases, and backup data out of Git. Fetch third-party assets through declared externals rather than committing downloaded bundles.

## Existing Context

- `roles/base/tasks/main.yml:14-41` currently applies chezmoi before most packages and deletes `aur_builder` before `roles/desktop/tasks/fancontrol.yml` uses it. Move the existing finalization tasks to the desktop caller after its package phase; do not build around the old ordering with deferred setup.
- Package lists already mix official and AUR packages through `kewlfft.aur.aur`; keep that pattern rather than introducing another installer.
- `home/dot_config/fish/config.fish` intentionally delegates configuration to `conf.d/`.
- `home/dot_config/kglobalshortcutsrc:382-384` currently assigns `Alt+Space` to KRunner.
- `home/.chezmoiignore:4-22` already excludes Linux-only targets on macOS.
- Vicinae supplies `/usr/lib/systemd/user/vicinae.service` and `/usr/share/applications/vicinae.desktop`. Its `toggle` desktop action executes `vicinae toggle`; bind that action rather than restarting the server through the main desktop entry.
- Vicinae 0.28.1 already loads a native KDE settings provider on Plasma. No extension is needed to search and open the installed `kcm_*` settings modules.
- User-service operations use the same unprivileged target-account context as the existing Syncthing tasks and chezmoi apply. Provisioning requires that account's working systemd user session; do not run Vicinae as root or `aur_builder`.

## 1. Finalize After Package Installation

Rename `roles/base/tasks/03b-chezmoi.yml` to `roles/base/tasks/19-chezmoi.yml`. Name the new service task `20-vicinae.yml`, leaving `99-aur-builder.yml` last in alphanumeric order.

In `roles/base/tasks/main.yml`, remove the early chezmoi include and final AUR-builder cleanup include. Update all references to the renamed file, including the generated chezmoi configuration's ownership comment and pointers in the other role files. The macOS role's documentation pointer changes, but its behavior does not.

In `roles/desktop/tasks/main.yml`, immediately after `fancontrol.yml`, add:

```yaml
- include_role:
    name: base
    tasks_from: 19-chezmoi.yml

- include_role:
    name: base
    tasks_from: 99-aur-builder.yml
```

The resulting sequence is common packages, desktop hardware packages, chezmoi setup/apply, then AUR-builder cleanup. The existing chezmoi task file still installs its own deployment dependencies before applying configuration. Selecting `tasks_from` does not rerun the base role's main task list.

The desktop role is the only active caller of base in this repository. Keep the macOS role unchanged. Preserve the existing display-configuration block and unrelated tasks.

The Vicinae service task introduced in section 4 will be inserted between chezmoi apply and cleanup, once that task file exists.

## 2. Package Additions

Append these exact package identifiers to the existing `name` lists; preserve existing entries and task structure.

| Existing Task File | Additions | Package Source |
|---|---|---|
| `roles/base/tasks/04-terminal.yml` | `navi`, `ouch`, `visidata`, `jless`, `trippy` | Official Arch repositories |
| `roles/base/tasks/09-media.yml` | `easyeffects` in the media-editor/tools list | Official Arch repositories |
| `roles/base/tasks/12-gaming.yml` | `ludusavi-bin` | AUR |
| `roles/base/tasks/15-dev-tools.yml` | `lazydocker`, `devtoys-bin` | Official / AUR respectively |
| `roles/base/tasks/17-kde.yml` | `vicinae-bin` | AUR |
| `roles/base/tasks/18-gui-tools.yml` | `localsend-bin`, `krokiet-bin`, `krename` | AUR / AUR / official respectively |

Package identifiers and availability were checked against the Arch and AUR APIs. Use repository versions rather than adding version pins or downloading releases ourselves.

> [!NOTE]
> `localsend-bin` is currently flagged out-of-date relative to the source-built `localsend` package. Prefer the binary package for this minimal setup, consistent with the existing README wishlist, and disclose this in the implementation summary. Recheck availability before implementation; do not silently substitute a source build or another distribution method if the package becomes unavailable.

No separate application configuration is necessary merely to install these packages. Documentation will describe the entire workstation toolset, not just these additions; see section 6.

## 3. Fish Integration And navi

Add these lines to the existing custom-convenience section of `home/dot_config/fish/conf.d/abbrs.fish`, matching its current pattern:

```fish
abbr -a pack 'ouch compress'
abbr -a unpack 'ouch decompress'
```

Create `home/dot_config/fish/conf.d/navi.fish`, following the existing Starship initialization pattern:

```fish
if status is-interactive
    navi widget fish | source
end
```

| Abbreviation | Example Expansion |
|---|---|
| `pack src bundle.zip` | `ouch compress src bundle.zip` |
| `unpack bundle.zip --dir extracted` | `ouch decompress bundle.zip --dir extracted` |

Create `home/dot_config/navi/config.yaml`:

```yaml
client:
  tealdeer: true
```

Add `.config/navi` and `.config/fish/conf.d/navi.fish` to the existing non-Linux block in `home/.chezmoiignore`. This enables explicit commands such as `navi --tldr tar --print`; it does not change the existing `help` abbreviation or replace the stock navi widget.

### Managed Cheat Sheets

Append this entry inside the existing Linux-only block in `home/.chezmoiexternal.toml.tmpl`:

```toml
[".local/share/navi/cheats/denisidoro"]
    type = "archive"
    url = "https://github.com/denisidoro/cheats/archive/1339965e9615ce00174cc308a41279d9c59aa75f.tar.gz"
    stripComponents = 1
    exact = true
    include = [
        "*/code/git.cheat",
        "*/container/docker.cheat",
        "*/misc/compression.cheat",
        "*/misc/json.cheat",
        "*/misc/shell.cheat",
        "*/misc/systemctl.cheat",
        "*/network/curl.cheat",
        "*/network/network.cheat",
        "*/pkg_mgr/pacman.cheat",
        "*/pkg_mgr/flatpak.cheat",
        "*/security/ssh.cheat",
        "*/security/openssl.cheat",
    ]
```

The collection is pinned to a verified upstream commit and includes the selected recipes plus OpenSSL certificate/conversion recipes. Broader command-specific coverage remains available through the enabled TLDR integration.

Keep `exact` scoped to the named collection, preserving unrelated collections. Update the external file's introductory comment to cover its managed asset types. No generated Fish code or custom cheat-sheet recipes are vendored.

## 4. Vicinae Startup And Shortcut

### Ansible-Managed User Service

Create `roles/base/tasks/20-vicinae.yml`:

```yaml
- name: KDE | Enable Bluetooth support
  tags: software,customization,KDE
  become: true
  ansible.builtin.systemd_service:
    name: bluetooth.service
    enabled: true
    state: started

- name: KDE | Enable and start Vicinae
  tags: software,customization,KDE
  become: false
  ansible.builtin.systemd_service:
    name: vicinae.service
    scope: user
    enabled: true
    state: "{{ 'restarted' if chezmoi_apply.changed else 'started' }}"
    daemon_reload: true
```

The Bluetooth task supports the selected extension using the existing BlueZ installation; preserve pairings, trust settings, and radio preferences. Machines without Bluetooth hardware naturally have no devices to expose. Leave the existing SSH service configuration untouched.

In `roles/desktop/tasks/main.yml`, insert the following between the `19-chezmoi.yml` and `99-aur-builder.yml` role-task includes:

```yaml
- include_role:
    name: base
    tasks_from: 20-vicinae.yml
```

The existing registered `chezmoi_apply.changed` result controls whether Vicinae is restarted to load deployed assets or simply ensured running. This restarts on any change reported by that apply task; an unchanged run leaves an already-running launcher alone.

Do not add a chezmoi service-enablement symlink, custom service unit, separate KDE Autostart entry, manual service-start tutorial, or extra `.config/systemd` ignore rule.

### Default Launcher

In `home/dot_config/kglobalshortcutsrc`, preserve KRunner's section but change its launch binding:

```ini
[services][org.kde.krunner.desktop]
RunClipboard=none
_launch=none
```

Add the packaged Vicinae desktop action:

```ini
[services][vicinae.desktop]
_launch=none
toggle=Alt+Space
```

Do not change the Meta application menu, Klipper's `Meta+V`, PlasmaZones shortcuts, or unrelated KDE settings. Do not uninstall or mask KRunner.

Use a fresh Plasma login to validate shortcut registration. Do not add a blanket desktop restart or change the existing KWin reload hook, which is not a shortcut-registration mechanism.

## 5. Managed Vicinae Extensions

Add these archive declarations inside the Linux-only block in `home/.chezmoiexternal.toml.tmpl`:

```toml
[".local/share/vicinae/extensions/store.vicinae.arch-packages"]
    type = "archive"
    format = "zip"
    url = "https://api.vicinae.com/v1/store/rithvikvibhu/arch-packages/download"
    stripComponents = 1
    exact = true
    refreshPeriod = "168h"

[".local/share/vicinae/extensions/store.vicinae.systemd"]
    type = "archive"
    format = "zip"
    url = "https://api.vicinae.com/v1/store/knoopx/systemd/download"
    stripComponents = 1
    exact = true
    refreshPeriod = "168h"

[".local/share/vicinae/extensions/store.vicinae.ssh"]
    type = "archive"
    format = "zip"
    url = "https://api.vicinae.com/v1/store/leiserfg/ssh/download"
    stripComponents = 1
    exact = true
    refreshPeriod = "168h"

[".local/share/vicinae/extensions/store.vicinae.bluetooth"]
    type = "archive"
    format = "zip"
    url = "https://api.vicinae.com/v1/store/gelei/bluetooth/download"
    stripComponents = 1
    exact = true
    refreshPeriod = "168h"

[".local/share/vicinae/extensions/store.vicinae.process-manager"]
    type = "archive"
    format = "zip"
    url = "https://api.vicinae.com/v1/store/leonkohli/process-manager/download"
    stripComponents = 1
    exact = true
    refreshPeriod = "168h"
```

These verified store endpoints return prebuilt ZIPs with a single enclosing directory. Vicinae discovers the extracted bundles on startup; no npm build, registration command, or manual store interaction is needed. Scope `exact` to each managed extension, not the extensions parent directory.

Create `home/dot_config/vicinae/settings.json` with the selected Process Manager restriction:

```json
{
  "providers": {
    "@leonkohli/store.vicinae.process-manager": {
      "entrypoints": {
        "kill": {
          "enabled": false
        }
      }
    }
  }
}
```

Keep the interactive Process Manager view enabled. Other extension preferences use their defaults. This settings file is chezmoi-managed like the other application configuration files; later intentional GUI preference changes can be captured through the existing config-maintenance workflow. Runtime data remains separate and unmanaged.

Add `.config/vicinae` to the non-Linux ignore block. The external declarations themselves must remain Linux-gated to prevent macOS downloads.

| Extension | Integration |
|---|---|
| Arch Packages | Read-only official/AUR package search; no account or preferences required |
| Systemd | Existing system/user services and logs, with normal authorization for service actions |
| SSH | Existing SSH host configuration and credentials; host discovery reads the main `~/.ssh/config` and does not follow `Include` directives |
| Bluetooth | Existing adapters/devices through BlueZ; no pairing or radio-policy automation |
| Process Manager | Interactive process inspection; separate unconfirmed bulk-kill entrypoint disabled |

**Update policy:** fresh machines receive the current store bundles. Chezmoi checks expired cached downloads when invoked after 168 hours; this is not a background updater or an immutable version pin. The Ansible apply-then-restart sequence loads completed deployments. Do not promise transactional updates or live reload from a standalone `chezmoi apply`; avoid running extension commands during deployment.

## 6. Workstation Documentation

Keep `README.md` concise: a desktop overview table, the Ansible/chezmoi architecture, the essential config workflow, and links to deeper documentation. The overview should identify CachyOS/Arch, KDE Plasma/Wayland, PlasmaZones, Fish/Starship, Konsole/Yakuake, Vicinae, Zed, and the main appearance components. Do not invent screenshots or move the entire app inventory into the README.

Create `docs/tools.md` for the detailed categorized catalogue of **all useful existing applications and the 13 additions**, plus the selected launcher extensions. Use small per-category tables with names, short purposes, and command names where useful. Include basic desktop applications even when supplied by the base KDE installation.

| Category | Catalogue Coverage |
|---|---|
| Desktop and terminals | Dolphin, Konsole, Yakuake, Vicinae |
| Shell and navigation | Fish, Starship, fzf, zoxide, tealdeer/tldr, navi, tmux |
| Files, search, archives | eza, bat, moor, fd, ripgrep, tree, Superfile, Filelight, ouch, Krokiet, KRename |
| Editors and developer tools | Zed, Neovim, Cursor, micro, OpenCode, Git, lazygit, Meld, Bruno, DevToys |
| Containers and virtual machines | Docker, lazydocker, virt-manager |
| Data exploration | jq, jless, VisiData |
| Development environments | Python, Node.js, Go, Rust/rustup, Java, Deno, Yarn, uv; concise coverage rather than runtime-dependency detail |
| Browsers and communication | Zen Browser, Chromium, Vesktop, Telegram Desktop, Zoom |
| Notes and office | Obsidian, OnlyOffice |
| Sync, transfers, downloads | Syncthing, SyncthingTray and its installed CLI/conflict helpers, LocalSend, rsync, curl, wget, aria2, qBittorrent |
| Media playback | VLC, mpv, Haruna, Feishin, Fladder |
| Audio, recording, creation | Audacity, Helvum, EasyEffects, OBS Studio, Kdenlive, FFmpeg, HandBrake, GIMP, KolourPaint |
| Gaming and compatibility | Steam, Lutris, Prism Launcher, ProtonUp-Qt, Wine, Winetricks, Proton-GE, Gamescope, GOverlay, Sunshine, Ludusavi; identify Heroic, MangoHud, and Protontricks as CachyOS-bundle coverage |
| Mods and gaming peripherals | r2modman, Modrinth App, Vortex, CKAN, PDX-Unlimiter, GX52 |
| Monitoring, networking, credentials | btop, Fastfetch, Wireshark, Nmap, Trippy, WireGuard tools, Bitwarden, GnuPG, CoolerControl |
| KDE appearance and behavior | PlasmaZones, Klassy, KWin Glass, Thermal Monitor, Blurred Wallpaper, Wallpaper Engine integration, Event Calendar, Arch Update Notifier, Panel Colorizer, Catppuccin, Monaspace Nerd Font |

Documentation rules:

- Clearly label `docs/tools.md` as the **Arch workstation setup**; macOS application installation remains manual.
- Describe Dolphin and Konsole as expected KDE/CachyOS desktop applications, not new explicit package declarations. Distinguish metapackage coverage from individual installs where appropriate.
- Omit Partition Manager, build dependencies, low-level libraries/drivers, and internal deployment helpers from the app catalogue. Explain chezmoi/Ansible in the setup overview rather than padding the tool list.
- Do not count commented legacy task references, the empty language-server list, or remaining wishlist entries as installed software.
- Put the short `pack`/`unpack`, `Ctrl+G`, explicit `navi --tldr`, and `Alt+Space` usage examples in `docs/tools.md`, linked from the README. Leave the existing `help` behavior unchanged.
- Preserve useful existing chezmoi workflow instructions, theme/config ownership explanations, and future-work items. Remove the now-covered LocalSend and launcher-choice wishlist entries.
- Reconcile every catalogue entry against the active task files during implementation; keep download/runtime data and secrets out of the docs and repository.

## Implementation Boundaries

Organize the work into five independently reviewable changes:

1. **Provisioning order:** rename the chezmoi task to `19-chezmoi.yml`, update its references, and move finalization/cleanup after the desktop package phase.
2. **Package declarations:** add the 13 selected applications to their existing lists, without redeclaring base-system dependencies.
3. **Fish tooling:** add `pack`/`unpack` to `abbrs.fish`, add the native navi initialization and compatibility setting, update Linux ignore entries, and declare the upstream cheat-sheet external.
4. **Vicinae integration:** add `20-vicinae.yml`, replace the launcher binding, and deploy the selected extension bundles and launcher settings.
5. **Documentation:** simplify the README overview and add the full catalogue and usage reference in `docs/tools.md`.

Suggested commit subjects, if commits are explicitly requested:

```text
fix: finalize desktop setup after package installation
feat: install additional desktop and CLI utilities
feat: integrate CLI tools with fish
feat: use Vicinae as the Plasma launcher
docs: catalogue workstation tools and workflows
```

Do not include unrelated fixes or refactors, and do not create commits without authorization.

## Verification

### Safe Local Checks

- [ ] Run `git diff --check` and inspect the complete diff for unintended changes.
- [ ] Run `ansible-playbook --syntax-check local.yml` and validate the changed YAML task files. The existing syntax check passes, but dynamic includes mean that check alone does not prove package-task execution works.
- [ ] Inspect the task sequence and all renamed-file references: common and desktop packages precede `19-chezmoi.yml`; `20-vicinae.yml` follows apply; cleanup follows the last AUR consumer. Confirm selected `tasks_from` includes do not rerun base's main task list.
- [ ] Confirm every selected package occurs in its intended task list, with no unexpected substitutions or changes to macOS installation.
- [ ] Run Fish syntax checks on `home/dot_config/fish/conf.d/abbrs.fish` and `home/dot_config/fish/conf.d/navi.fish`, and validate the new YAML/JSON configuration files.
- [ ] Verify the two plain abbreviation expansions and preserve existing abbreviations, including `help`. On Linux with navi installed, verify its startup file initializes the stock widget only in interactive shells.
- [ ] Validate navi's pinned archive paths, including the OpenSSL addition, and the five Vicinae ZIP layouts. Confirm manifest authors and installed directory names match the managed provider ID.
- [ ] With chezmoi available, inspect Linux/Darwin target state without applying hooks to the real home. Only Linux receives the new navi/Vicinae configuration and downloaded assets; no managed service-enablement symlink is added.
- [ ] Cross-check `docs/tools.md` against active package declarations, desktop-default exceptions, and metapackage annotations. Validate the README link and concise desktop overview.

### Arch/KDE Acceptance Checks

- [ ] Verify package installation on the intended Arch host or a suitable test environment. Do not run the whole provisioning playbook merely as a test: it includes unrelated filesystem operations.
- [ ] Run the new integration in the intended desktop-user context. Confirm BlueZ support and the enabled Vicinae user service. Confirm reported chezmoi changes cause a launcher restart and an unchanged apply leaves an already-running launcher alone.
- [ ] Confirm the package exposes the `toggle` desktop action. After a Plasma login, `Alt+Space` must open/close Vicinae without restarting its server or also opening KRunner.
- [ ] Confirm KRunner remains installed and the existing Meta menu, Klipper shortcut, and PlasmaZones bindings still work.
- [ ] Test application launching, a calculation, currency conversion, and native KDE settings search. Confirm all five selected extensions are available on a fresh deployment without manual installation, and the Process Manager bulk-kill command is disabled.
- [ ] Check session/power commands are offered with default confirmations, but do not execute logout, suspend, shutdown, or power-profile changes during automated validation.
- [ ] In a fresh navi data directory deployed by chezmoi, `Ctrl+G` must show the selected upstream cheat sheets without prompting to install a collection, and insert a selected command for review.
- [ ] Test `pack` and `unpack` with a disposable sample archive. Verify a sample JSON document in jless and explicit `navi --tldr tar --print` using tealdeer; confirm `help` and stock `Ctrl+G` retain their agreed behavior.
- [ ] Exercise read-only extension functionality: Arch package search, service status/logs, process listing, SSH host discovery, and Bluetooth device listing where hardware is present. Do not kill processes, change system services, pair devices, or open remote connections as part of automated checks.
- [ ] Confirm a second chezmoi diff shows no drift from the managed targets. Unrelated collections/extensions and application runtime data must remain untouched.

**Environment limits:** The current host is macOS. Ansible and Fish are available, but chezmoi, navi, and desktop-file validation tooling were not found on PATH; `kewlfft.aur` was not listed among installed collections. Obtain validation dependencies only in an approved implementation environment, or report the affected checks as pending. Do not claim Linux GUI, package, or systemd behavior was tested from this host.
