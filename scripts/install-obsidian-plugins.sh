#!/usr/bin/env bash
# install-obsidian-plugins.sh
# -----------------------------------------------------------------------------
# Downloads the *code* (main.js, manifest.json, styles.css) for every community
# plugin listed in a vault's community-plugins.json. Only the plugin code is
# fetched here; the per-plugin settings (data.json) are versioned in the repo
# and deployed separately by the Ansible Obsidian task.
#
# Plugin IDs are resolved to their GitHub repos via Obsidian's official plugin
# registry (obsidianmd/obsidian-releases), so nothing has to be hardcoded.
#
# Usage:
#   install-obsidian-plugins.sh <vault-config-dir>
#
# where <vault-config-dir> is the vault's .obsidian directory, e.g.
#   install-obsidian-plugins.sh "$HOME/Documents/Obsidian Vault/.obsidian"
#
# Idempotent: an existing plugin is re-downloaded only if its versioned
# manifest.json advertises a newer version than what's installed (or if the
# plugin's main.js is missing).
# -----------------------------------------------------------------------------

set -eu

REGISTRY_URL="https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/community-plugins.json"

CONFIG_DIR="${1:-}"
if [ -z "$CONFIG_DIR" ]; then
  echo "usage: $(basename "$0") <vault-config-dir>" >&2
  exit 1
fi
if [ ! -d "$CONFIG_DIR" ]; then
  echo "vault config dir not found: $CONFIG_DIR" >&2
  exit 1
fi

PLUGINS_LIST="$CONFIG_DIR/community-plugins.json"
PLUGINS_DIR="$CONFIG_DIR/plugins"
if [ ! -f "$PLUGINS_LIST" ]; then
  echo "no community-plugins.json in $CONFIG_DIR - nothing to do"
  exit 0
fi

for bin in curl jq; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "required command not found: $bin" >&2
    exit 1
  fi
done

mkdir -p "$PLUGINS_DIR"

echo "Fetching Obsidian plugin registry..."
REGISTRY=$(curl -fsSL "$REGISTRY_URL")

# Read enabled plugin IDs (one per line).
PLUGIN_IDS=$(jq -r '.[]' "$PLUGINS_LIST")

for id in $PLUGIN_IDS; do
  repo=$(printf '%s' "$REGISTRY" | jq -r --arg id "$id" '.[] | select(.id == $id) | .repo')
  if [ -z "$repo" ] || [ "$repo" = "null" ]; then
    echo "  ! $id: not found in registry, skipping" >&2
    continue
  fi

  dest="$PLUGINS_DIR/$id"
  base="https://github.com/$repo/releases/latest/download"

  # Determine the latest published version from the repo's release manifest.
  latest_ver=$(curl -fsSL "$base/manifest.json" 2>/dev/null | jq -r '.version // empty' || true)
  if [ -z "$latest_ver" ]; then
    echo "  ! $id: could not read latest release manifest, skipping" >&2
    continue
  fi

  # Skip if already up to date and the code is present.
  if [ -f "$dest/main.js" ] && [ -f "$dest/manifest.json" ]; then
    current_ver=$(jq -r '.version // empty' "$dest/manifest.json" 2>/dev/null || true)
    if [ "$current_ver" = "$latest_ver" ]; then
      echo "  = $id: up to date ($current_ver)"
      continue
    fi
  fi

  echo "  + $id: installing $latest_ver from $repo"
  mkdir -p "$dest"
  # main.js and manifest.json are mandatory; styles.css is optional.
  curl -fsSL "$base/main.js" -o "$dest/main.js"
  curl -fsSL "$base/manifest.json" -o "$dest/manifest.json"
  curl -fsSL "$base/styles.css" -o "$dest/styles.css" 2>/dev/null || true
done

echo "Obsidian plugins installed."
