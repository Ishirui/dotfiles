# Replace ls with eza
abbr -a ls 'eza -al --color=always --group-directories-first --icons' # preferred listing
abbr -a la 'eza -a --color=always --group-directories-first --icons'  # all files and dirs
abbr -a ll 'eza -l --color=always --group-directories-first --icons'  # long format
abbr -a lt 'eza -aT --color=always --group-directories-first --icons' # tree listing
abbr -a l. "eza -a | grep -e '^\.'"                                    # show only dotfiles

# Common use
abbr -a grubup "sudo grub-mkconfig -o /boot/grub/grub.cfg"
abbr -a fixpacman "sudo rm /var/lib/pacman/db.lck"
abbr -a tarnow 'tar -acf '
abbr -a untar 'tar -zxvf '
abbr -a wget 'wget -c '
abbr -a psmem 'ps auxf | sort -nr -k 4'
abbr -a psmem10 'ps auxf | sort -nr -k 4 | head -10'
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
abbr -a ..... 'cd ../../../..'
abbr -a ...... 'cd ../../../../..'
abbr -a dir 'dir --color=auto'
abbr -a vdir 'vdir --color=auto'
abbr -a grep 'grep --color=auto'
abbr -a fgrep 'fgrep --color=auto'
abbr -a egrep 'egrep --color=auto'
abbr -a hw 'hwinfo --short'                                   # Hardware Info
abbr -a big "expac -H M '%m\t%n' | sort -h | nl"              # Sort installed packages according to size in MB
abbr -a gitpkg 'pacman -Q | grep -i "\-git" | wc -l'          # List amount of -git packages
abbr -a update 'sudo pacman -Syu'

# Get fastest mirrors
abbr -a mirror "sudo cachyos-rate-mirrors"

# Help people new to Arch
abbr -a apt 'man pacman'
abbr -a apt-get 'man pacman'
abbr -a please 'sudo'
abbr -a tb 'nc termbin.com 9999'

# Cleanup orphaned packages
abbr -a cleanup 'sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
abbr -a jctl "journalctl -p 3 -xb"

# Recent installed packages
abbr -a rip "expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
