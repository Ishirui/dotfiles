set -q STARSHIP_CONFIG; or set -Ux STARSHIP_CONFIG ~/.config/fish/starship.toml

if status is-interactive
    source (starship init fish --print-full-init | psub)
end
