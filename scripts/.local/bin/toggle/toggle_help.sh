#!/bin/sh

# grep -v grep: remove the "grep 'zathura -'" command from the list the grep returns.
# Recall that 'zathura -' is zathura running from stdin.
PID=$(ps aux | grep "zathura -" | grep -v grep | awk "{ print \$2 }")
# echo ">$PID<"
if [[ -n $PID ]]; then
	# echo "We need to kill a doc open"
	kill -9 $PID # 2>&1 /dev/null
else
	# echo "We need to open a new doc"
	groff -mom -tbl $HOME/.local/help/system_help.mom -Tpdf | zathura - &
fi
