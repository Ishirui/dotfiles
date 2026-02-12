# Replace common commands with their modern alternatives
abbr -a nano "micro"
abbr -a cat "bat"
abbr -a find "fd"
abbr -a htop "btop"
abbr -a cd "zoxide"

# Custom convenience
abbr -a fdg "fd --glob"
abbr -a help "tldr" # Overwrites default fish help but eh
abbr -a zed "zeditor"

# Shortcuts
abbr -a c "clear"
abbr -a h "history"

# Git
## Add
abbr -a -- ga 'git add'
## Info on current HEAD
abbr -a -- gbn 'git rev-parse --abbrev-ref HEAD' # Get current branch name
abbr -a -- gb 'git rev-parse HEAD' # Get current commit hash
## Commit
abbr -a -- gc 'git commit'
abbr -a -- gca 'git commit -a'
abbr -a -- gc! 'git commit --amend'
abbr -a -- gc!! 'git commit --amend --no-edit'
abbr -a -- gc? 'git commit --no-verify'
abbr -a -- gc?! 'git commit --amend --no-verify'
abbr -a -- gc!? 'git commit --amend --no-verify'
## Checkout
abbr -a -- gco 'git checkout'
abbr -a -- gcb 'git checkout -b '
abbr -a -- gcm 'git checkout main'
## Log
abbr -a -- glo 'git log --oneline --decorate'
abbr -a -- glog 'git log --oneline --decorate --graph'
## Push-pull-clone
abbr -a -- gp 'git push'
abbr -a -- gpsuo 'git push --set-Upstream origin (git rev-parse --abbrev-ref HEAD)'
abbr -a -- gl 'git pull'
abbr -a -- gcl 'git clone'
## Cherry-pick
abbr -a -- gcp 'git cherry-pick'
abbr -a -- gcpx 'git cherry-pick -x'
## Rebase
abbr -a -- grb 'git rebase'
abbr -a -- grbi 'git rebase --interactive'
abbr -a -- grbim 'git rebase --interactive main'
## Misc
abbr -a -- gpristine 'git reset --hard && git clean -fdx'

# Common use - CachyOS defaults
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

# Cleanup orphaned packages
abbr -a cleanup 'sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
abbr -a jctl "journalctl -p 3 -xb"

# Recent installed packages
abbr -a rip "expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
