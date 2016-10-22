# Path to your oh-my-zsh installation.
export TERM="xterm-256color"
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="arrow"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git archlinux)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=/usr/bin/:$PATH:$HOME/bin:/usr/local/bin
export XILINX_PATH=/home/zach/Xilinx/14.7/ISE_DS
export EDITOR="emacs -nw"
export PYTHONPATH=$HOME/Documents/scripts/MacroManX/
export GOPATH=~/.golang
#export JAVA_HOME=/usr/java/

# Auto-completion helpers:
export FPATH=~/.zsh/completion:$FPATH
autoload -U compinit
compinit

# Prompt settings:
autoload -Uz promptinit
promptinit
prompt redhat
#PROMPT="%T
#[%{$fg_no_bold[cyan]%}%n%b%f@%m %{$fg_bold[cyan]%}%1~%b%f]%F{magenta}%(!.#.%%)%f "
#RPROMPT="%B%F{red}%(?..%? )%F%B"
PROMPT="%B%F{red}%(?..%? )%f%b%F{cyan}[%j running job(s)] %f%F{green}{history#%!} %f%F{red}%(3L.+ .)%f%B%F{blue}%D{%H:%M:%S} %f%F{blue}%D{%Y-%m-%d}%f%b
%F{red}└-%B%F{blue}%n%f%b@%m %B%40<..<%~%<< %b%# "

winemode()
{
    if [ "$1" = "32" ]
    then
        export WINEPREFIX=~/.wine32
        export WINEARCH=win32
    elif [ -z "$1" ] || [ "$1" = "64" ]
    then
        export WINEPREFIX=~/.wine
        export WINEARCH=win64
    fi
    
}

moviemode()
{
    while [ 1 ]
    do
        xscreensaver-command -deactivate 
        sleep 300s
    done
}

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ls="ls -FA --group-directories-first --color=auto"
alias emacs="emacs -nw"
alias zxconfig="emacs -nw ~/.zshrc; echo -n 'Sourcing... '; source ~/.zshrc; echo 'Done.'"
alias -s pdf="zathura"
alias adbon='sudo adb start-server'
alias adboff='adb kill-server'
alias terminal='xfce4-terminal'
#alias wlan0-illinoisnet='sudo netctl start IllinoisNet'
alias wyeFi='sudo netctl start'
alias pacman='pacman --color always'
alias DELETED!='rm'
alias clipEdit='xclip -o -selection clipboard'
alias xcf2jpg='batch_level.py 0 255'
alias remolevl='perl-rename "s/-levl//" *'
alias ethreset='sudo ip link set enp9s0 down; sudo netctl start ethernet-dhcp'
alias forgotpi='python -c "import math; print(math.pi)"'
alias yoaurt='yaourt'
alias cliptrim="xclip -o -selection clipboard | tr -d '\n' | xclip -selection clipboard"
alias getflashpid="ps -U zach | grep plug | grep -oP '(?<= )\d+ '"
#alias plz='sudo'
alias unescape="sed -e 's/%/\\\\x/g' | python -c \"import sys, codecs; print(codecs.decode(sys.stdin.readline(),'unicode_escape'))\""
alias zathcpy="xclip -o | xclip -selection clipboard"

# Anti-grep_options thing
alias grep="/usr/bin/grep --color=always"
unset GREP_OPTIONS

#disable shared history.
unsetopt share_history

#Miscellaneous config stuff, just in case.
if xset q &>/dev/null; then
	xset r rate 225 30
fi
