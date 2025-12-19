#!/bin/zsh
# vim:foldmethod=marker
# vim:foldmarker=#{{{,#}}}

# Adds `~/.local/bin` to $PATH
if [ -d "$HOME/.local/bin" ] || [ -h "$HOME/.local/bin" ] ;
    then export PATH="$PATH:${$(find -H ~/.local/bin -not -path '*/.git/*' -type d -printf %p:)%%:}"
fi

unsetopt PROMPT_SP

#{{{ zsh
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export HISTORY_IGNORE="(ls|ll|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
export LESSHISTFILE="-"
#}}}

#{{{ default programs
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="zen-browser"
export VISUAL='nvim'
export HOSTNAME=$(hostname)
export PKG_MANAGER='yay'
export FILE_EXPLORER='thunar'
export PAGER='bat --plain'
export GIT_PAGER='bat --plain'
#}}}

#{{{ xdg
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/shell/inputrc"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/password-store"
export XCOMPOSEFILE="${XDG_CONFIG_HOME:-$HOME/.config}/x11/xcompose"
#}}}

#{{{ fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
export FZF_DEFAULT_OPTS="--layout=reverse --height 60%"
#}}}

#{{{ bat
export BAT_THEME=base16
#}}}

#{{{ less
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
#}}}

#{{{ gtk/qt
# export QT_QPA_PLATFORMTHEME="gtk2" # Have QT use gtk2 theme.
export QT_QPA_PLATFORMTHEME="qt5ct"
#}}}

#{{{ mozilla 
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.
#}}}

#{{{ valgrind 
# The line below was added to make the valgrind work, according to https://bbs.archlinux.org/viewtopic.php?id=276422
export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"
#}}}

#{{{ c/cpp 
export CXX="/usr/bin/clang++"
export CC="/usr/bin/clang"
#}}}

#{{{ rust
if [ -d "$HOME/.cargo/bin" ] || [ -h "$HOME/.cargo/bin" ];then 
    export PATH="$PATH:$HOME/.cargo/bin"
fi
#}}}

#{{{ zvm (zig version manager)
if [ -d "$HOME/.zvm" ] || [ -h "$HOME/.zvm" ]; then
  export ZVM_INSTALL="$HOME/.zvm/self"
  export PATH="$PATH:$HOME/.zvm/bin"
  export PATH="$PATH:$ZVM_INSTALL/"
fi
#}}}

#{{{ go
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
if [ -d "$HOME/.local/share/go/bin" ] || [ -h "$HOME/.local/share/go/bin" ]; then
    export PATH="$PATH:$HOME/.local/share/go/bin"
fi
#}}}

#{{{ haskell 
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env
#}}}

