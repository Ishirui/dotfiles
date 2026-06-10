#!/usr/bin/env bash
# Shared Starship palette data for build-starship-configs.sh and
# starship-palettes.sh.

# Theme token order:
#   host dir flair_1 flair_2 git [alert ssh container]
# The last 3 tokens default to red/sky/teal when omitted.
declare -A STARSHIP_THEMES=(
  [rosé]="mauve lavender pink flamingo rosewater"
  [bloom]="peach pink mauve lavender sky"
  [iris]="sapphire sky lavender mauve pink"
  [twilight]="mauve lavender blue peach flamingo"
  [twilight-bloom]="mauve lavender blue teal sky"
  [halcyon]="flamingo mauve sapphire sky lavender"
  [spring]="peach green teal sapphire lavender"
  [garden]="peach yellow green teal sapphire"
  [moonrise]="mauve lavender sapphire sky teal"
  [petal]="flamingo pink mauve lavender sapphire"
  [orchid]="green teal mauve lavender sky"
)

STARSHIP_THEME_ORDER=(
  rosé
  bloom
  iris
  twilight
  twilight-bloom
  halcyon
  spring
  garden
  moonrise
  petal
  orchid
)

# Hostname from `hostname -s` -> theme name from STARSHIP_THEMES.
# Hosts not listed here fall back through Ansible to starship.default.toml.
declare -A STARSHIP_HOST_THEMES=(
  [Tesseract]="iris"             # NAS - cool blues into pink
  [Cuboid]="twilight-bloom"      # gaming rig - cool gradient ending in teal/sky
  [Vertex]="rosé"                # personal laptop - pinks
  [COMP-DL7Q42TMVM]="twilight"   # work mac - spacey
  [default]="rosé"               # fallback for vm-* and unknown hosts
)

STARSHIP_HOST_ORDER=(
  Tesseract
  Cuboid
  Vertex
  COMP-DL7Q42TMVM
  default
)

# Catppuccin Macchiato hex values.
declare -A STARSHIP_MACCHIATO_HEX=(
  [rosewater]='#f4dbd6'
  [flamingo]='#f0c6c6'
  [pink]='#f5bde6'
  [mauve]='#c6a0f6'
  [red]='#ed8796'
  [maroon]='#ee99a0'
  [peach]='#f5a97f'
  [yellow]='#eed49f'
  [green]='#a6da95'
  [teal]='#8bd5ca'
  [sky]='#91d7e3'
  [sapphire]='#7dc4e4'
  [blue]='#8aadf4'
  [lavender]='#b7bdf8'
)

starship_theme_def() {
  local theme=$1
  local theme_def="${STARSHIP_THEMES[$theme]:-}"
  if [ -z "$theme_def" ]; then
    echo "unknown theme: $theme" >&2
    return 1
  fi
  printf '%s\n' "$theme_def"
}

starship_color_hex() {
  local name=$1
  local value="${STARSHIP_MACCHIATO_HEX[$name]:-}"
  if [ -z "$value" ]; then
    echo "unknown color: $name (not in catppuccin_macchiato)" >&2
    return 1
  fi
  printf '%s' "$value"
}
