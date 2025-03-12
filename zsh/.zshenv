#!/bin/zsh

# profile file. Runs on interactive login shell (only once).
# Environmental variables are best set here.

# Adds `~/.local/bin` to $PATH
if [ -d "$HOME/.local/bin" ] || [ -h "$HOME/.local/bin" ] ;
    # then export PATH="$PATH:${$(find ~/.local/bin -type d -printf %p:)%%:}"
    then export PATH="$PATH:${$(find -H ~/.local/bin -not -path '*/.git/*' -type d -printf %p:)%%:}"
fi
# Added on May 31st 2024 to support tree-sit-cli installation with cargo.
if [ -d "$HOME/.cargo/bin" ] || [ -h "$HOME/.cargo/bin" ] ;
    then export PATH="$PATH:$HOME/.cargo/bin:$HOME/.cargo/env"
fi

unsetopt PROMPT_SP

# Default programs:
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="zen-browser"
export VISUAL='nvim'
export HOSTNAME=$(hostname)
# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
export XCOMPOSEFILE="${XDG_CONFIG_HOME:-$HOME/.config}/x11/xcompose"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
# export NOTMUCH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/notmuch-config"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/shell/inputrc"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/password-store"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"

# Cedilha not working inside chromium in Wayland.
# source: https://plus.diolinux.com.br/t/a-letra-c-esta-aparecendo-ao-inves-de-c-cedilha-no-google-chrome-ao-configurar-flag-ozone-platform-hint-para-wayland/66571/5
export GTK_IM_MODULE=cedilla
export QT_IM_MODULE=cedilla

export HISTORY_IGNORE="(ls|ll|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"

# Other program settings:
# export DICS="/usr/share/stardict/dic/"
# export SUDO_ASKPASS="$HOME/.local/bin/dmenu/dmenu_pass"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
# export FZF_DEFAULT_OPTS="--layout=reverse --height 60% --preview 'bat --color=always {}'"
export FZF_DEFAULT_OPTS="--layout=reverse --height 60%"
# export BAT_THEME=tokyonight_night
export BAT_THEME=zenburn
##==== [ These control pretty print in terminal ] ====
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
#============================================================
# export QT_QPA_PLATFORMTHEME="gtk2"	# Have QT use gtk2 theme.
export QT_QPA_PLATFORMTHEME="qt5ct"	# Have QT use gtk2 theme.
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.

# On June 23rd, 2022.
# The line below was added to make the valgrind work, according to https://bbs.archlinux.org/viewtopic.php?id=276422
export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"

export CXX="/usr/bin/clang++"
export CC="/usr/bin/clang"
