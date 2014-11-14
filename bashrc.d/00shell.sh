# Bash completion
[[ -f /etc/profile.d/bash-completion.sh ]] && source /etc/profile.d/bash-completion.sh

# Do not show duplicate lines
export HISTCONTROL=ignorespace:erasedups

# Give history timestamps
export HISTTIMEFORMAT="[%F %T] "
