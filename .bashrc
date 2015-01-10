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
# Path dir in user's home
##
PATH="${PATH}:${HOME}/bin"


##
# Use pretty PS1
##
source "${HOME}/.bash_prompt"


##
# Use aliases
##
source "${HOME}/.alias"


##
# Colors for Man Pages
##
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline


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

