
# Function to source files if they exist
function zsh_add_file() {
    [ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
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

zinit light zsh-users/zsh-autosuggestions
zinit light momo-lab/zsh-abbrev-alias

# Add in zsh plugins 
zinit wait lucid for \
   zsh-users/zsh-syntax-highlighting \
   zsh-users/zsh-completions \
   Aloxaf/fzf-tab \

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
zinit snippet OMZP::mvn
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose

# Load completions
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files.

zinit cdreplay -q

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

export KEYTIMEOUT=15

# Custom ZSH Binds
bindkey '^ ' autosuggest-accept
bindkey -v '^?' backward-delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load aliases and shortcuts if existent.
[ -f "$XDG_CONFIG_HOME/shell/aliasrc" ] && source "$XDG_CONFIG_HOME/shell/aliasrc"
[ -f "$XDG_CONFIG_HOME/shell/shortcutrc" ] && source "$XDG_CONFIG_HOME/shell/shortcutrc"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# =================================================
# Source fzf keybindings
# Selan, on June 21st, 2023
# -------------------------------------------------
source <(fzf --zsh)
zstyle ':fzf-tab:complete:(j|cd):*' fzf-preview 'exa --color=always $realpath'

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



# Zoxide plugin
eval "$(zoxide init zsh --cmd j)"

