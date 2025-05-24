#!/usr/bin/env bash

projects="$HOME/Public/Personal/ $HOME/Public/Work/ $HOME/Public/OneDrive/Cave/Projects/ $HOME/Public/OneDrive/Cave/Projects/2025.1-ufrn/ $HOME/Dotfiles/"
selected=$(find $projects -maxdepth 1 -mindepth 1 -type d | fzf)

if [[ -z "$selected" ]]; then
  exit 0
fi
selected_name=$(basename "$selected" | tr ".,: " "____")

switch_to() {
  if [[ -z "$TMUX" ]]; then
    tmux attach-session -t "$selected_name"
  else
    tmux switch-client -t "$selected_name"
  fi
}

if tmux has-session -t="$selected_name"; then
  switch_to
else
  tmux new-session -ds "$selected_name" -c "$selected"
  switch_to
fi
