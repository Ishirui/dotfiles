set -q PAGER; or set -Ux PAGER moor
set -q VISUAL; or set -Ux VISUAL "zeditor --wait"
set -q EDITOR; or set -Ux EDITOR micro

# Fix Incus CLI and Incus terraform provider not looking in the same place on macOS
set -q INCUS_CONF; or set -Ux INCUS_CONF $HOME/.config/incus
