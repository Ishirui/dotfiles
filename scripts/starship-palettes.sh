#!/usr/bin/env bash
# starship-palettes.sh — render the starship prompt under various 5-color
# palettes, hosts, and dynamic states. Outputs ANSI escape codes; pipe to a
# truecolor terminal:
#
#   bash dotfiles/scripts/starship-palettes.sh                   # all palettes × all hosts
#   bash dotfiles/scripts/starship-palettes.sh bloom             # one palette × all hosts
#   bash dotfiles/scripts/starship-palettes.sh '' mac            # all palettes × one host
#   bash dotfiles/scripts/starship-palettes.sh bloom mac         # default state
#   bash dotfiles/scripts/starship-palettes.sh bloom mac root    # specific dynamic state
#   bash dotfiles/scripts/starship-palettes.sh bloom mac all     # all states for that combo
#
# Each palette is 5 colors in the visual order of the powerline:
#   host  →  dir  →  flair-1  →  flair-2  →  git
#
# States:
#   default | root | ssh | container | nogit | ro | fail | longcmd | all
#     default    — normal shell, in dotfiles, clean user
#     root       — $USER=root, red lock chip prepended to the bar
#     ssh        — $SSH_TTY set; sky pill with remote glyph appears next to host
#     container  — $REMOTE_CONTAINERS=1; teal pill with docker glyph next to host
#     nogit      — cwd outside any git repo (no git chip rendered)
#     ro         — cwd is a read-only path (red lock inside the dir chip)
#     fail       — last command exited 127 (status indicator + red character)
#     longcmd    — last command ran 4.5s (cmd_duration indicator)
#     all        — show every state for the chosen palette × host
#
# Override the source config:
#   STARSHIP_SOURCE=~/.config/starship.toml bash …/starship-palettes.sh

set -u

WANT_PALETTE=${1:-}
WANT_HOST=${2:-}
WANT_STATE=${3:-default}

# Resolve repo root from this script's location, regardless of cwd.
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
DOTFILES_ROOT=$(cd -- "$SCRIPT_DIR/.." >/dev/null 2>&1 && pwd)
SRC=${STARSHIP_SOURCE:-$DOTFILES_ROOT/fish/starship.toml.template}

if [ ! -f "$SRC" ]; then
  echo "starship source not found: $SRC" >&2
  exit 1
fi

# Ephemeral working dir for mocked configs and read-only test paths.
WORK=${TMPDIR:-/tmp}/starship-palettes
mkdir -p "$WORK"

# Read-only test path (created on demand).
RO_DIR="$WORK/ro"
if [ ! -d "$RO_DIR" ]; then
  mkdir -p "$RO_DIR"
  touch "$RO_DIR/file"
  chmod -w "$RO_DIR"
fi

# Build a `hostname`-mockable copy of the source: replace the literal
# `hostname -s` shell call inside [custom.host] with `echo $HOSTNAME_OVERRIDE`,
# so we can spoof the hostname per render without touching the original.
MOCK="$WORK/mocked.toml"
# shellcheck disable=SC2016
# $HOSTNAME_OVERRIDE is intentionally literal — interpreted later by the
# bash subshell that runs the [custom.host] command snippet.
sed 's/hostname -s/echo $HOSTNAME_OVERRIDE/g' "$SRC" > "$MOCK"

ALL_STATES=(default root ssh container nogit ro fail longcmd)

# Catppuccin Macchiato hex values — used to swap the c_* palette aliases
# defined in the template.
declare -A HEX=(
  [rosewater]='#f4dbd6' [flamingo]='#f0c6c6' [pink]='#f5bde6' [mauve]='#c6a0f6'
  [red]='#ed8796' [maroon]='#ee99a0' [peach]='#f5a97f' [yellow]='#eed49f'
  [green]='#a6da95' [teal]='#8bd5ca' [sky]='#91d7e3' [sapphire]='#7dc4e4'
  [blue]='#8aadf4' [lavender]='#b7bdf8'
)

# Render once: palette × host × state.
# Args: pname  hc  dc  fc1  fc2  gc  hn  state
render_one() {
  local pname=$1 hc=$2 dc=$3 fc1=$4 fc2=$5 gc=$6 hn=$7 state=$8
  local cfg="$WORK/palette.toml"

  # The template uses semantic palette aliases (c_host, c_dir, c_f1, c_f2,
  # c_git) so we just rewrite their hex values in the [palettes] block. No
  # per-module color substitution required — inline-tail symbol colors stay
  # exactly as they are in the template.
  sed \
    -e "s|^c_host      = '[^']*'.*|c_host      = '${HEX[$hc]}'  # $hc|"  \
    -e "s|^c_dir       = '[^']*'.*|c_dir       = '${HEX[$dc]}'  # $dc|"  \
    -e "s|^c_f1        = '[^']*'.*|c_f1        = '${HEX[$fc1]}'  # $fc1|" \
    -e "s|^c_f2        = '[^']*'.*|c_f2        = '${HEX[$fc2]}'  # $fc2|" \
    -e "s|^c_git       = '[^']*'.*|c_git       = '${HEX[$gc]}'  # $gc|"  \
    "$MOCK" > "$cfg"

  # Per-state variables.
  local user_v=plv ssh_v="" container_v="" cwd="$DOTFILES_ROOT" status_v=0 dur_v=0 lbl_extra=""
  case "$state" in
    default)   ;;
    root)      user_v=root ; lbl_extra='+root' ;;
    ssh)       ssh_v=/dev/pts/0 ; lbl_extra='+ssh' ;;
    container) container_v=1 ; lbl_extra='+container' ;;
    nogit)     cwd=/tmp ; lbl_extra='+nogit' ;;
    ro)        cwd="$RO_DIR" ; lbl_extra='+ro' ;;
    fail)      status_v=127 ; lbl_extra='+fail' ;;
    longcmd)   dur_v=4500 ; lbl_extra='+longcmd' ;;
    *) echo "unknown state: $state" >&2 ; return ;;
  esac

  local hlbl
  case "$hn" in
    COMP-DL7Q42TMVM) hlbl='mac    ' ;;
    Tesseract)       hlbl='nas    ' ;;
    Cuboid)          hlbl='desktop' ;;
    Vertex)          hlbl='laptop ' ;;
    vm-foo)          hlbl='vm     ' ;;
    random-box)      hlbl='unknown' ;;
    *)               hlbl=$hn      ;;
  esac

  # Compose the side label: "mac     +root" etc.
  printf '  \033[38;5;245m%-7s %-9s\033[0m  ' "$hlbl" "$lbl_extra"

  # Print prompt + right prompt on same line.
  env -i HOME="$HOME" PATH="$PATH" TERM="${TERM:-xterm-256color}" \
    USER="$user_v" HOSTNAME_OVERRIDE="$hn" SSH_TTY="$ssh_v" REMOTE_CONTAINERS="$container_v" \
    STARSHIP_CONFIG="$cfg" \
    bash --noprofile --norc -c "
      cd '$cwd' 2>/dev/null
      starship prompt --status=$status_v --cmd-duration=$dur_v 2>/dev/null | head -1
    "
  # Right prompt on its own indented line for clarity.
  local rp
  rp=$(env -i HOME="$HOME" PATH="$PATH" TERM="${TERM:-xterm-256color}" \
    USER="$user_v" HOSTNAME_OVERRIDE="$hn" SSH_TTY="$ssh_v" REMOTE_CONTAINERS="$container_v" \
    STARSHIP_CONFIG="$cfg" \
    bash --noprofile --norc -c "
      cd '$cwd' 2>/dev/null
      starship prompt --right --status=$status_v --cmd-duration=$dur_v 2>/dev/null
    ")
  if [ -n "$rp" ]; then
    printf '          \033[38;5;239m(right)\033[0m  %s\n' "$rp"
  fi
}

# Map a friendly host label (mac/nas/desktop/laptop/vm/unknown) to the
# `hostname -s` value the [custom.host] case statement expects.
resolve_host() {
  case "$1" in
    mac|"")  echo COMP-DL7Q42TMVM ;;
    nas)     echo Tesseract ;;
    desktop) echo Cuboid ;;
    laptop)  echo Vertex ;;
    vm)      echo vm-foo ;;
    unknown) echo random-box ;;
    *)       echo "$1" ;;
  esac
}

# Render a palette on ONE host. Each host now has a single configured theme,
# so iterating across all 6 hosts per palette would only change the leading
# glyph — not informative. Pick mac by default; the user can override with
# WANT_HOST.
render_palette() {
  local pname=$1 hc=$2 dc=$3 fc1=$4 fc2=$5 gc=$6
  if [ -n "$WANT_PALETTE" ] && [ "$pname" != "$WANT_PALETTE" ]; then return; fi

  printf '\n\033[1;38;5;245m══ %-22s\033[0m  %s → %s → %s → %s → %s\n' \
    "$pname" "$hc" "$dc" "$fc1" "$fc2" "$gc"

  local states=()
  if [ "$WANT_STATE" = all ]; then
    states=("${ALL_STATES[@]}")
  else
    states=("$WANT_STATE")
  fi

  local hn
  hn=$(resolve_host "$WANT_HOST")
  for st in "${states[@]}"; do
    render_one "$pname" "$hc" "$dc" "$fc1" "$fc2" "$gc" "$hn" "$st"
  done
}

# Render the actual per-host configs as built by the build script. Useful as
# a "what does each machine look like in real life" view.
render_live_hosts() {
  local cfg_dir="$DOTFILES_ROOT/fish/starship_configs"
  if [ ! -d "$cfg_dir" ]; then return; fi
  printf '\n\033[1;38;5;245m▆▆ live host configs\033[0m  '
  printf '(actual themes from fish/starship_configs/)\n'
  for host_cfg in "$cfg_dir"/starship.*.toml; do
    [ -e "$host_cfg" ] || continue
    local hn mocked
    hn=$(basename "$host_cfg" .toml | sed 's/^starship\.//')
    mocked="$WORK/showcase-$hn.toml"
    # shellcheck disable=SC2016
    sed 's/hostname -s/echo $HOSTNAME_OVERRIDE/g' "$host_cfg" > "$mocked"
    printf '  \033[38;5;245m%-22s\033[0m  ' "$hn"
    env -i HOME="$HOME" PATH="$PATH" TERM="${TERM:-xterm-256color}" \
      USER=plv HOSTNAME_OVERRIDE="$hn" SSH_TTY="" REMOTE_CONTAINERS="" \
      STARSHIP_CONFIG="$mocked" \
      bash --noprofile --norc -c "
        cd '$DOTFILES_ROOT' 2>/dev/null
        starship prompt 2>/dev/null
      " | head -1
  done
}

echo
echo "── starship palette demo ──"
echo "(source: $SRC)"
echo "(state: $WANT_STATE)"

# ============================================================================
# themes used by the build script (one per host in fish/starship_configs/)
# ============================================================================
render_palette "rosé"               mauve    lavender pink     flamingo rosewater
render_palette "garden"             peach    yellow   green    teal     sapphire
render_palette "halcyon"            flamingo mauve    sapphire sky      lavender
render_palette "twilight"           mauve    lavender blue     peach    flamingo
render_palette "iris"               sapphire sky      lavender mauve    pink

# ============================================================================
# more pastel gradients (host  dir  f1  f2  git)
# ============================================================================
render_palette "bloom"           peach    pink     mauve    lavender sky
render_palette "twilight-bloom"  mauve    lavender blue     teal     sky
render_palette "wisteria"        mauve    pink     lavender sky      sapphire
render_palette "warm-cool"       flamingo pink     lavender sapphire sky
render_palette "dawn-pastel"     flamingo pink     mauve    lavender sky

# ============================================================================
# new — pastel gradients with red / maroon accents
# ============================================================================
render_palette "tulip"           maroon   peach    pink     mauve    lavender
render_palette "heather"         peach    maroon   mauve    lavender sky
render_palette "sunset-rose"     maroon   peach    flamingo pink     mauve
render_palette "amaranth"        maroon   pink     mauve    lavender sky

# ============================================================================
# new — pastel gradients with green / teal accents
# ============================================================================
render_palette "spring"          peach    green    teal     sapphire lavender
render_palette "fresh"           green    teal     sapphire lavender mauve
render_palette "emerald"         green    sapphire lavender mauve    pink
render_palette "orchid"          green    teal     mauve    lavender sky
render_palette "botanic"         green    teal     lavender mauve    pink
render_palette "lagoon"          teal     sapphire lavender mauve    pink

# ============================================================================
# new — wider chromatic span (warm + green together)
# ============================================================================
render_palette "rainbow-soft"    peach    green    sapphire mauve    lavender
render_palette "garden"          peach    yellow   green    teal     sapphire
render_palette "blossom"         maroon   peach    green    teal     sapphire

# ============================================================================
# dynamic states showcase — applied to the current twilight theme on mac, so
# the SSH / container / root / nogit / etc. chips are visible without having
# to filter the demo with extra args. Skipped when the user is filtering by
# palette or state (they'll get tailored output already).
# ============================================================================
if [ -z "$WANT_PALETTE" ] && [ "$WANT_STATE" = default ] && [ -z "$WANT_HOST" ]; then
  render_live_hosts

  printf '\n\033[1;38;5;245m▆▆ dynamic states showcase\033[0m  garden on mac\n'
  for st in default root ssh container nogit ro fail longcmd; do
    render_one "garden" peach yellow green teal sapphire COMP-DL7Q42TMVM "$st"
  done
fi

echo
echo "Tips:"
echo "  bash $0 bloom              # one palette on the default host (mac)"
echo "  bash $0 bloom nas          # one palette on a different host"
echo "  bash $0 bloom mac all      # one palette × one host × every state"
echo "  bash $0 '' '' all          # every palette × default host × every state"
echo "  STARSHIP_SOURCE=~/.config/fish/starship.toml bash $0 …"
echo "                             # preview themes against the live config"
