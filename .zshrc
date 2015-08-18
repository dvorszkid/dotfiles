##
# Zgen and Prezto
##
source "${HOME}/.local/share/zgen/zgen.zsh"

# Autoreload if .zshrc has changed
ZGEN_RESET_ON_CHANGE=("${HOME}/$(readlink ~/.zshrc)")

# Load zgen
if ! zgen saved; then
	# Set case-sensitivity for completion, history lookup, etc.
	zgen prezto "*" case-sensitive 'no'

	# Color output (auto set to 'no' on dumb terminals)
	zgen prezto "*" color 'yes'

	# Set the key mapping style to 'emacs' or 'vi'
	zgen prezto editor key-bindings 'vi'

	# Auto convert .... to ../..
	zgen prezto editor dot-expansion 'yes'

	# Ignore submodules when they are 'dirty', 'untracked', 'all', or 'none'
	zgen prezto git:status:ignore submodules 'all'

	# Custom theme
	zgen prezto prompt theme 'cylon'

	# Auto set the tab and window titles
	zgen prezto terminal auto-title 'yes'

	# Set the Prezto modules to load (the order matters)
	ZGEN_PREZTO_LOAD_DEFAULT=0
	zgen prezto
	zgen prezto archive
	zgen prezto environment
	zgen prezto terminal
	zgen prezto editor
	zgen prezto history
	zgen prezto directory
	zgen prezto utility
	zgen prezto completion
	zgen prezto prompt
	zgen prezto git
	zgen prezto tmux
	zgen prezto syntax-highlighting
	zgen prezto history-substring-search

	# Other plugins
	zgen load radhermit/gentoo-zsh-completions src
	zgen load t413/zsh-background-notify
	zgen load ${HOME}/.local/share/zsh-prompt-cylon

	# Save all to init script
	zgen save
fi


##
# Custom options
##
setopt nonomatch # pass the unevaluated argument like bash
setopt print_exit_value
unsetopt rm_star_silent
unsetopt share_history


##
# Custom keys
##

# History search
bindkey "$key_info[PageUp]" history-substring-search-up
bindkey "$key_info[PageDown]" history-substring-search-down

# Open man page for current command
bindkey "^Xm" run-help

# Control + arrows to navigate words
for key in "${(s: :)key_info[ControlLeft]}"
	bindkey -M viins "$key" backward-word
for key in "${(s: :)key_info[ControlRight]}"
	bindkey -M viins "$key" forward-word


##
# Shared resources
##
source "$HOME/.alias"
source "$HOME/.env"


##
# Get notified when someone logs in
##
watch=all                       # watch all logins
logcheck=30                     # every 30 seconds
WATCHFMT="%n from %M has %a tty%l at %T %W"

