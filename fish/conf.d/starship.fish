set -q STARSHIP_CONFIG; or set -Ux STARSHIP_CONFIG ~/.config/fish/starship.toml
source (/usr/bin/starship init fish --print-full-init | psub)
