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

source "$SCRIPT_DIR/starship-theme-data.sh"

if [ ! -f "$TEMPLATE" ]; then
  echo "template not found: $TEMPLATE" >&2
  exit 1
fi
mkdir -p "$OUT_DIR"

# render <output_basename> <theme_name>
render() {
  local basename=$1 theme=$2
  local theme_def
  theme_def=$(starship_theme_def "$theme")

  # Theme tokens: host dir f1 f2 git [alert ssh container]
  read -r h d f1 f2 g alert ssh container <<<"$theme_def"
  alert=${alert:-red}
  ssh=${ssh:-sky}
  container=${container:-teal}

  local hex_h hex_d hex_f1 hex_f2 hex_g hex_alert hex_ssh hex_container
  hex_h=$(starship_color_hex "$h")
  hex_d=$(starship_color_hex "$d")
  hex_f1=$(starship_color_hex "$f1")
  hex_f2=$(starship_color_hex "$f2")
  hex_g=$(starship_color_hex "$g")
  hex_alert=$(starship_color_hex "$alert")
  hex_ssh=$(starship_color_hex "$ssh")
  hex_container=$(starship_color_hex "$container")

  local out="$OUT_DIR/starship.${basename}.toml"

  # Replace each c_* palette entry's hex value. The template stores the original
  # color name in a trailing `# comment` for readability; we rewrite both.
  sed \
    -e "s|^c_host      = '[^']*'.*|c_host      = '$hex_h'  # $h|" \
    -e "s|^c_dir       = '[^']*'.*|c_dir       = '$hex_d'  # $d|" \
    -e "s|^c_f1        = '[^']*'.*|c_f1        = '$hex_f1'  # $f1|" \
    -e "s|^c_f2        = '[^']*'.*|c_f2        = '$hex_f2'  # $f2|" \
    -e "s|^c_git       = '[^']*'.*|c_git       = '$hex_g'  # $g|" \
    -e "s|^c_alert     = '[^']*'.*|c_alert     = '$hex_alert'  # $alert|" \
    -e "s|^c_ssh       = '[^']*'.*|c_ssh       = '$hex_ssh'  # $ssh|" \
    -e "s|^c_container = '[^']*'.*|c_container = '$hex_container'  # $container|" \
    "$TEMPLATE" \
  > "$out"

  printf '  → %-32s  %s (%s → %s → %s → %s → %s)\n' \
    "starship.${basename}.toml" "$theme" "$h" "$d" "$f1" "$f2" "$g"
}

ONLY=${1:-}

echo "Rendering starship configs from $TEMPLATE"
for host in "${STARSHIP_HOST_ORDER[@]}"; do
  if [ -n "$ONLY" ] && [ "$ONLY" != "$host" ]; then continue; fi
  render "$host" "${STARSHIP_HOST_THEMES[$host]}"
done

if [ -z "$ONLY" ]; then
  count=$(find "$OUT_DIR" -maxdepth 1 -name 'starship.*.toml' | wc -l | tr -d ' ')
  echo
  echo "Wrote $count host configs into $OUT_DIR."
  echo "Commit and re-run Ansible to deploy."
fi
