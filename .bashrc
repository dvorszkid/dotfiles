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


##
# Start tmux on ssh
##
if [ -z "$STARTED_TMUX" ] && [ -n "$SSH_TTY" ]
then
  case $- in
    (*i*)
      STARTED_TMUX=1; export STARTED_TMUX
      tmux-home || echo "Tmux failed! Continuing with normal bash startup."
  esac
fi

