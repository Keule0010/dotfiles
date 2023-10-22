## Set values
# Hide welcome message
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

## Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

## Environment setup
if test -f ~/.fish_profile
  source ~/.fish_profile
end

export EDITOR=nvim
export VISUAL=nvim

## Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

## Starship prompt
if type -q starship && status --is-interactive
   source ("/usr/bin/starship" init fish --print-full-init | psub)
end

## Functions
# Fish command history
function history
    builtin history --show-time='%F %T '
end

function ba --argument filename
    cp $filename $filename.bak
end

function cp_bar
    cp $argv[1] $argv[2] &
    set cpid $last_pid

    progress -mp $cpid
    kill $cpid &> /dev/null
end

# Maven
function mvn-init -a groupId artifactId -d "Create a simple maven project"
    if test -z "$groupId" -o -z "$artifactId"
        echo -e "Usage: mvn-init <groupId> <artifactId>\ngroupId or artifactId missing!"
    else
        mvn archetype:generate -DgroupId=$groupId -DartifactId=$artifactId -DinteractiveMode=false
    end
end

function mvn-run -a mainClass -d "Run your current maven project"
    if test -z "$mainClass"
        echo -e "Usgae: mvn-run <mainClass> [arguments]\nmainClass missing!"
    else
        set args ""
        for arg in $argv[2..-1]
            set args "$args $arg"
        end

        if test -z $args
            mvn clean compile exec:java -Dexec.mainClass="$mainClass"
        else
            mvn clean compile exec:java -Dexec.mainClass="$mainClass" -Dexec.args="$args"
        end
    end
end

## Aliases
# Replace ls with exa
if type -q exa
    alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
    alias la='exa -a --color=always --group-directories-first --icons'  # all files and dirs
    alias ll='exa -l --color=always --group-directories-first --icons'  # long format
    alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
    alias l.='exa -ald --color=always --group-directories-first --icons .*' # show only dotfiles
end

# Replace cat with bat
if type -q bat
    alias cat='bat --style header --style snip --style changes --style header'
end

# Common use
alias ipn='ip'
alias nano=nvim
alias cls='clear'
alias please='sudo'
alias ip='ip -color'
alias mkdirs='mkdir --parents'
alias ssh="kitty +kitten ssh" #For kitty terminal or use (on client)-> sudo apt install kitty-terminfo
alias grubup="sudo update-grub"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias tarlist="tar -tvf"
alias untar='tar -xvf '
alias wget='wget -c '
alias rmpkg="sudo pacman -Rcns "
alias purgepkg="sudo pacman -Rdd "
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias fgrep='grep -F --color=auto'
alias egrep='grep -E --color=auto'
alias igrep='grep -i --color=auto'
alias hw='hwinfo --short'                           # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl"      # Sort installed packages according to size in MB
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'  # List amount of -git packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'     # Cleanup orphaned packages
alias jctl="journalctl -p 3 -xb"                    # Get the error messages from journalctl
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl" # Recent installed packages

# Get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

## Run fastfetch if session is interactive
if status --is-interactive 
    if type -q fastfetch
        fastfetch -l arch
    else if type -q neofetch
        neofetch --ascii_distro arch
    end
end
