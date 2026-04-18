# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

path_prepend() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1${PATH:+:$PATH}" ;;
    esac
}

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'



alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


GUIX_PROFILE="/home/ysong/.guix-profile"
[ -f "$GUIX_PROFILE/etc/profile" ] && . "$GUIX_PROFILE/etc/profile"

#export LD_LIBRARY_PATH="$HOME/.guix-profile/lib:$LD_LIBRARY_PATH"

#export LD_LIBRARY_PATH="/usr/lib/wsl/lib:$HOME/.guix-profile/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
#export GALLIUM_DRIVER=d3d12
#export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA


[ -f "$HOME/.local/share/../bin/env" ] && . "$HOME/.local/share/../bin/env"

export NVM_DIR="/home/ysong/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"


path_prepend "$HOME/.local/lib/flutter/bin"

export HTTP_PROXY=http://127.0.0.1:8081
export HTTPS_PROXY=http://127.0.0.1:8081
path_prepend "$HOME/.npm-global/bin"
#export DISPLAY=127.0.0.1:0.0

export EDITOR=vi
export COLORTERM=truecolor
path_prepend "$HOME/.local/bin"
path_prepend "/mnt/d/VSCodium/bin"
eval "$(direnv hook bash)"


alias lll='echo -e "\033[1;34m$(pwd)\033[0m";ls -lh --color=always | awk '\''NR>1 {printf "%-7s %-3s %2s %-5s ", $5, $6, $7, $8; for(i=9; i<=NF; i++) printf $i (i==NF ? "" : " "); print ""}'\'''
alias emc="emacsclient -nw ."
alias p4="proxychains4"
alias cc="claude"
alias open="explorer.exe"
alias f="flutter run -d linux"
alias cls="clear"

alias rcc="ccr code"


path_prepend "$HOME/.local/share/zig"

alias winfix='[ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ] && sudo sh -c "echo \":WSLInterop:M::MZ::/init:PF\" > /proc/sys/fs/binfmt_misc/register"'

# bun
export BUN_INSTALL="$HOME/.bun"
path_prepend "$BUN_INSTALL/bin"



export KEP_COMPILE_RESOURCE_PATH="/home/ysong/codz/icapp/material-resources"

export MVN_INSTALL="/home/ysong/.local/share/maven"
path_prepend "$MVN_INSTALL/bin"


export M2_HOME="$HOME/.m2"
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/"

# pnpm
export PNPM_HOME="/home/ysong/.local/share/pnpm"
path_prepend "$PNPM_HOME"
# pnpm end

prompt_prefix=
if [ -n "$GUIX_ENVIRONMENT" ]; then
    prompt_prefix='[env] '
fi

PS1="${debian_chroot:+($debian_chroot)}${prompt_prefix}\[\e[1;36m\]\W\[\e[m\] \[\e[1;33m\]❯\[\e[m\] "

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
esac
unset prompt_prefix

# fzf 选择文件并复制到剪贴板
fname(){ selected=$(ls | fzf --height 40% --reverse) || return; printf %s "$selected" | xclip -selection clipboard; }
fpath(){ selected=$(fdfind -t f | fzf --height 40% --reverse) || return; printf %s "$selected" | xclip -selection clipboard; }

alias _history_fzf='READLINE_LINE=$(history | sed "s/ *[0-9]* *//" | sort -u | tac | fzf --height 40% --reverse); READLINE_POINT=${#READLINE_LINE}'
bind -x '"\C-r": _history_fzf'
