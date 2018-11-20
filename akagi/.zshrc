ZSH=/usr/share/oh-my-zsh/
plugins=(git archlinux)
source $ZSH/oh-my-zsh.sh

export TERM=xterm-256color

# Alises:
alias ls="ls -FA --group-directories-first --color=auto"
#alias emacs="emacs -nw"
alias zxconfig="vim ~/.zshrc; echo -n 'Sourcing... '; source ~/.zshrc; echo 'Done.'"
alias pacman='pacman --color always'
alias unmute='amixer -D pulse set Master Playback Switch toggle'
alias startx='ssh-agent startx'
alias xcf2jpg='batch_level.py 0 255'
#alias grep='/usr/bin/grep --color=always'

# Exports
export PATH="/home/zach/bin":$PATH

export HOMEWIFISSID="wlp5s0-134Wildberry5.0"
alias connecthome="sudo netctl start $HOMEWIFISSID"

# Get rid of that pesky beep that keeps giving me a heart attack
setterm -blength 0 2> /dev/null

autoload -Uz promptinit
promptinit
prompt redhat
export EDITOR="subl -w"

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' prompt 'Errors %e'
zstyle :compinstall filename '/home/zach/.zshrc'

# Key configurations:
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        echoti smkx
    }
    function zle-line-finish () {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
#  End key config

bindkey ';5D' emacs-backward-word
bindkey ';5C' emacs-forward-word
#bindkey '^[[1;2A' up-line-or-history
#bindkey '^[[1;2B' down-line-or-history
bindkey -s '^[[1;2A' ''
bindkey -s '^[[1;2B' ''

# The following lines were added by compinstall
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select=1

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd notify
bindkey -e
# End of lines configured by zsh-newuser-install

#prompts:
autoload -U colors && colors
autoload -U promptinit
promptinit

# Prompt settings:
autoload -Uz promptinit
promptinit
prompt redhat
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

#Variables/more setopts:
setopt HIST_IGNORE_DUPS AUTO_PUSHD PUSHDIGNOREDUPS
unsetopt share_history
setopt prompt_cr prompt_sp 

#Other things:
# rmmod pcspkr
