#!/bin/sh

# ================================================================================
# Profile file. Runs on interactive login shell (only once).
# This is called AFTER the zshenv has been sourced.
# ================================================================================

# --------------------------------------------------------------------------------
# From ChatGPT:
# --------------------------------------------------------------------------------
# In a Linux environment with zsh as the main shell, the `.zprofile` script is 
# typically used to set up environment variables, define paths, and perform any
# other initialization tasks that should be executed once upon login.
# 
# Remember, the `.zprofile` script is sourced only for login shells, meaning 
# it's executed when you log in or start a new session. If you want 
# configurations to be applied to every new shell instance, you might consider 
# putting them in `.zshrc` instead, which is sourced for interactive non-login shells.
# --------------------------------------------------------------------------------


# Added on January 30th 2024 source: https://wiki.archlinux.org/title/SSH_keys#Keychain
#====================[ START-Keychain ]====================#
# Let  re-use ssh-agent and/or gpg-agent between logins
eval `keychain --eval --quiet --noask --agents ssh --ignore-missing id_ed25519 id_rsa id_ed25519_cf`
source "$HOME/.keychain/$(hostname)-sh"
#====================[ End-keychain ]====================#

# ## Alternative for the script above
# # source: https://wiki.archlinux.org/title/SSH_keys#ssh-agent_as_a_wrapper_program
# alias startx='ssh-agent startx'

## MPD daemon start (if no other user instance exists)
# [ ! -s ~/.config/mpd/pid ] && mpd
