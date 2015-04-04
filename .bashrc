# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


##
# Bash completion
##
[[ -f /etc/profile.d/bash-completion.sh ]] && source /etc/profile.d/bash-completion.sh


##
# History control
##
export HISTCONTROL=ignorespace:erasedups  # Do not show duplicate lines
export HISTTIMEFORMAT="[%F %T] "          # Give history timestamps


##
# Use pretty PS1
##
source "${HOME}/.bash_prompt"


##
# Shared resources
##
source "$HOME/.alias"
source "$HOME/.env"

