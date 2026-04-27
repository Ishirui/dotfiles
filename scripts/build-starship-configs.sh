#!/usr/bin/env bash
# build-starship-configs.sh
# -----------------------------------------------------------------------------
# Renders fish/starship.toml.template into one fish/starship.<hostname>.toml
# per host, swapping the 8 c_* semantic palette entries for theme-specific
# values. The Ansible terminal role then deploys the matching variant to each
# machine as ~/.config/fish/starship.toml.
#
# Re-run after editing the template, the theme catalog, or the host map:
#
#   bash dotfiles/scripts/build-starship-configs.sh
#
# To preview a single host:
#
#   bash dotfiles/scripts/build-starship-configs.sh Tesseract
# -----------------------------------------------------------------------------

set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
DOTFILES=$(cd -- "$SCRIPT_DIR/.." >/dev/null 2>&1 && pwd)
TEMPLATE="$DOTFILES/fish/starship.toml.template"
OUT_DIR="$DOTFILES/fish/starship_configs"

if [ ! -f "$TEMPLATE" ]; then
  echo "template not found: $TEMPLATE" >&2
  exit 1
fi
mkdir -p "$OUT_DIR"

# -----------------------------------------------------------------------------
# Theme catalog: theme_name → "host dir flair_1 flair_2 git alert ssh container"
# (last 3 default to red/sky/teal; override per theme if you want.)
# -----------------------------------------------------------------------------
declare -A themes=(
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

# -----------------------------------------------------------------------------
# Host map: hostname (output of `hostname -s`) → theme name from the catalog.
# Hosts not listed here fall back to the `default` entry, which is rendered
# as fish/starship.default.toml so Ansible can `with_first_found` to it.
# -----------------------------------------------------------------------------
declare -A hosts=(
  [Tesseract]="iris"               # NAS — cool blues into pink
  [Cuboid]="twilight-bloom"        # gaming rig — cool gradient ending in teal/sky
  [Vertex]="rosé"                  # personal laptop — pinks
  [COMP-DL7Q42TMVM]="garden"       # work mac — earthy
  [default]="rosé"                 # fallback (used for vm-* and any unknown host)
)

# -----------------------------------------------------------------------------
# Catppuccin Macchiato hex values — the source of truth for color name → hex.
# -----------------------------------------------------------------------------
declare -A hex=(
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

# Validate a color name has a hex value.
ensure_hex() {
  local name=$1
  if [ -z "${hex[$name]:-}" ]; then
    echo "unknown color: $name (not in catppuccin_macchiato)" >&2
    exit 1
  fi
}

# render <output_basename> <theme_name>
render() {
  local basename=$1 theme=$2
  local theme_def="${themes[$theme]:-}"
  if [ -z "$theme_def" ]; then
    echo "unknown theme: $theme" >&2
    exit 1
  fi

  # Theme tokens: host dir f1 f2 git [alert ssh container]
  read -r h d f1 f2 g alert ssh container <<<"$theme_def"
  alert=${alert:-red}
  ssh=${ssh:-sky}
  container=${container:-teal}

  for c in "$h" "$d" "$f1" "$f2" "$g" "$alert" "$ssh" "$container"; do
    ensure_hex "$c"
  done

  local out="$OUT_DIR/starship.${basename}.toml"

  # Replace each c_* palette entry's hex value. The template stores the original
  # color name in a trailing `# comment` for readability; we rewrite both.
  sed \
    -e "s|^c_host      = '[^']*'.*|c_host      = '${hex[$h]}'  # $h|" \
    -e "s|^c_dir       = '[^']*'.*|c_dir       = '${hex[$d]}'  # $d|" \
    -e "s|^c_f1        = '[^']*'.*|c_f1        = '${hex[$f1]}'  # $f1|" \
    -e "s|^c_f2        = '[^']*'.*|c_f2        = '${hex[$f2]}'  # $f2|" \
    -e "s|^c_git       = '[^']*'.*|c_git       = '${hex[$g]}'  # $g|" \
    -e "s|^c_alert     = '[^']*'.*|c_alert     = '${hex[$alert]}'  # $alert|" \
    -e "s|^c_ssh       = '[^']*'.*|c_ssh       = '${hex[$ssh]}'  # $ssh|" \
    -e "s|^c_container = '[^']*'.*|c_container = '${hex[$container]}'  # $container|" \
    "$TEMPLATE" \
  > "$out"

  printf '  → %-32s  %s (%s → %s → %s → %s → %s)\n' \
    "starship.${basename}.toml" "$theme" "$h" "$d" "$f1" "$f2" "$g"
}

ONLY=${1:-}

echo "Rendering starship configs from $TEMPLATE"
for host in "${!hosts[@]}"; do
  if [ -n "$ONLY" ] && [ "$ONLY" != "$host" ]; then continue; fi
  render "$host" "${hosts[$host]}"
done

if [ -z "$ONLY" ]; then
  count=$(find "$OUT_DIR" -maxdepth 1 -name 'starship.*.toml' | wc -l | tr -d ' ')
  echo
  echo "Wrote $count host configs into $OUT_DIR."
  echo "Commit and re-run Ansible to deploy."
fi
