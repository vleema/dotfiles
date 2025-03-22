# =============================================================================
# WARNING: PATH has already been set inside `/home/selan/.config/zsh/.zshenv`
# =============================================================================


# =================================================
# === Support functions
# -------------------------------------------------
# Function to source files if they exist
function zsh_add_file() {
    [ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
}

function zsh_add_plugin() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then 
        # For plugins
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    else
        git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
    fi
}

# =================================================
# === Prompt related
# ------------------------------------------------
# = Load a nice prompt
zsh_add_file  "zsh-prompt" 
# =================================================


# =================================================
# === Cursor related
# -------------------------------------------------
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
# -------------------------------------------------

# =================================================
# === General settings
# -------------------------------------------------
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt INTERACTIVE_COMMENTS
setopt MENU_COMPLETE       # Automatically highlight first element of completion menu
setopt LIST_PACKED         # The completion menu takes less space.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.

# =================================================
# === History related
# -------------------------------------------------
#===  History in cache directory:
# Note: $HISTSIZE should be at least 20% larger than $SAVEHIST.
HISTSIZE=13000000
SAVEHIST=10000000
export HISTTIMEFORMAT="[%F %T] "
# -------------------------------------------------
# 1. Immediate append
# Setting the INC_APPEND_HISTORY
# option ensures that commands are added to the history
# immediately (otherwise, this would happen only when
# the shell exits, and you could lose history upon
# unexpected/unclean termination of the shell).
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
# =================================================


# =================================================
# === Plugins
# -------------------------------------------------
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if there's none
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in PowerLevel10k
# zinit ice depth=1 ; zinit light romkatv/powerlevel10k

# Add in zsh plugins 
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light momo-lab/zsh-abbrev-alias

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# =================================================
# === Auto complete related
# -------------------------------------------------
#=== Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files.
#=== Add support to a case insensitive suggestion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# HERE WE HAVE TWO OPTIONS TO SHOW COMPLETION:
# [1]---------[ Regular list, vim navigation enabled ]------
# zstyle ':completion:*' menu select
# [2]---------[ fzf ]---------------------------------------
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa --color=always $realpath'
zsh_add_plugin "Aloxaf/fzf-tab"
# -------------------------------------------------


# =================================================
# === Setup zsh-hist plugin
# -------------------------------------------------
# Source: https://stackoverflow.com/questions/66055808/how-to-remove-unknown-commands-from-shell-terminal-history-zsh
# This will automatically delete the last command line from history, if it returned 127.
# Seek doc about the handler here: https://zsh.sourceforge.io/Doc/Release/index-frame.html
# autoload -Uz add-zsh-hook
# command_not_found_handler () {
# # Imprime o valor de $? para depuração
#   echo "Último código de retorno: $?"
#   # This is a commando from the plugin "marlonrichert/zsh-hist"
#  if (( $? == 127 )); then
#     echo "not found!"
#   fi
#  # (( ? == 127 )) && hist -fq delete -1
# }
# add-zsh-hook zshaddhistory  command_not_found_handler

autoload -Uz add-zsh-hook
# Função personalizada para tratar comandos não encontrados
command_not_found_handler() {
  # Retorna 127 para indicar que o comando não foi encontrado
  return 127
}
precmd_function() {
  if (( $? == 127 )); then
    # echo "not found!"
    # Remove o último comando do histórico
    hist -fq delete -1
  fi
}
# Adiciona o hook para verificar o código de retorno antes do prompt
add-zsh-hook precmd precmd_function

# =================================================
# === Activate vi mode
# -------------------------------------------------
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char
# -------------------------------------------------

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward


# Custom ZSH Binds
bindkey '^ ' autosuggest-accept
bindkey '^w' forward-word
bindkey '^b' backward-word
# bindkey '^[[C' forward-word # Right arrow. Press Ctrl+V and then the key you want know the code for.
# bindkey '^[[D' backward-word # Left arrow.
# bindkey '^[[C' forward-char # Right arrow. Press Ctrl+V and then the key you want know the code for.
# bindkey '^[[D' backward-char # Left arrow.

bindkey -s '^o' 'ranger\n'
# # bindkey -s '^a' 'bc -lq\n'
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'
bindkey '^[[P' delete-char
bindkey -r "^u"


# =================================================
# Change cursor shape for different vi modes.
# -------------------------------------------------
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
# =================================================

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shell/aliasrc" ] && source "$HOME/.config/shell/aliasrc"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# # Added Haskell support on July 22nd, 2022.
# [ -f "/home/selan/.ghcup/env" ] && source "/home/selan/.ghcup/env" # ghcup-env

# =================================================
# Source fzf keybindings
# Selan, on June 21st, 2023
# -------------------------------------------------
# source /usr/share/fzf/key-bindings.zsh
# source /usr/share/fzf/completion.zsh
# eval "$(fzf --zsh)"
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for details.
_fzf_compgen_path(){
  fd --hidden --exclude .git . "$1"
}

# Use fd to generatethe list for directory completion.
_fzf_compgen_dir(){
  fd --type=d --hidden --exclude .git . "$1"
}

_fzf_comprun(){
  local command=$1
  shift

  case "$command" in 
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$' {}"  "$@" ;;
    ssh)          fzf --preview 'dig {}'   "$@"  ;;
    tree)         fd . --type d | fzf --preview 'tree -C {}'   "$@"  ;;
    *)            fzf --preview "--preview 'bat -n --color=always --line-range :500 {}'"  "$@" ;;
  esac
}

# Yazi wrapper to change dir (navigation)
# Source: https://yazi-rs.github.io/docs/quick-start
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(\cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp" >/dev/null 2>&1
}
# =================================================
# Defininf a extraction function.
# -------------------------------------------------
# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}



# Flutter apps completion
if type complete &>/dev/null; then
  __flutter_completion() {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           flutter completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F __flutter_completion flutter
elif type compdef &>/dev/null; then
  __flutter_completion() {
    si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 flutter completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef __flutter_completion flutter
elif type compctl &>/dev/null; then
  __flutter_completion() {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       flutter completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K __flutter_completion flutter
fi

# Zoxide plugin
eval "$(zoxide init zsh)"

# Android studio configuraiton
export CHROME_EXECUTABLE=/opt/google/chrome/chrome
export ANDROID_HOME=$HOME/Android/Sdk/
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools/:$ANDROID_HOME/cmdline-tools/latest/bin/:$ANDROID_HOME/emulator/

#===============[ THE END ]====================================
