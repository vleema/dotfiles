#!/bin/bash

DIR1="/usr/bin"
DIR2="/bin"

Menu="$(ls -a $DIR1 $DIR2 | uniq -u \
    | fzf --prompt="Which Program Would You Like To Run?: " \
    --border=rounded \
    --color='bg:#1d2021,fg:#ebdbb2,hl:#444444' \
    --margin=5% \
    --height 100% \
    --reverse \
    --header="PROGRAMS: " --info=hidden)"

exec $Menu
