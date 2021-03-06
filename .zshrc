##
# Zgen and Prezto
##
source "${HOME}/.local/share/zgen/zgen.zsh"

# Autoreload if .zshrc has changed
ZGEN_RESET_ON_CHANGE=("$(realpath ~/.zshrc)")

# Load zgen
if ! zgen saved; then
	# Set case-sensitivity for completion, history lookup, etc.
	zgen prezto '*:*' case-sensitive 'no'

	# Color output (auto set to 'no' on dumb terminals)
	zgen prezto '*:*' color 'yes'

	# Set the key mapping style to 'emacs' or 'vi'
	zgen prezto editor key-bindings 'vi'

	# Do not auto convert .... to ../..
	zgen prezto editor dot-expansion 'no'

	# Ignore submodules when they are 'dirty', 'untracked', 'all', or 'none'
	zgen prezto git:status:ignore submodules 'all'

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
	zgen prezto completion
	zgen prezto prompt
	zgen prezto git
	zgen prezto syntax-highlighting
	zgen prezto history-substring-search

	# Other plugins
	zgen load gentoo/gentoo-zsh-completions src
	zgen load t413/zsh-background-notify
	zgen load dvorszkid/zsh-prompt-cylon

	# Custom theme
	zgen prezto prompt theme 'cylon'

	# Save all to init script
	zgen save
fi


##
# Custom options
##
setopt nonomatch # pass the unevaluated argument like bash
setopt print_exit_value
unsetopt rm_star_silent
setopt inc_append_history       # Appends every command to the history file once it is executed
setopt share_history            # Reloads the history whenever you use it
setopt glob_dots                # include dotfiles in globbing
unsetopt list_beep              # no bell on ambiguous completion
unsetopt hist_beep              # no bell on error in history
unsetopt beep                   # no bell on error
if [ ${TMUX} ]; then
	unset zle_bracketed_paste   # tmux does not support bracketed paste
fi


##
# Custom keys
##

# History search
bindkey "$key_info[PageUp]" history-substring-search-up
bindkey "$key_info[PageDown]" history-substring-search-down

# Open man page for current command
bindkey "^Xm" run-help

# Do not execute, just add to history
bindkey "^Xp" push-line-or-edit

# Edit current command in vim
bindkey "^Xv" edit-command-line

# Custom widget to store a command line in history without executing it
commit-to-history() {
  print -s ${(z)BUFFER}
  zle send-break
}
zle -N commit-to-history
bindkey "^Xh" commit-to-history

# Control + arrows to navigate words
for key in "${(s: :)key_info[ControlLeft]}"
	bindkey -M viins "$key" backward-word
for key in "${(s: :)key_info[ControlRight]}"
	bindkey -M viins "$key" forward-word


##
# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
##
KEYTIMEOUT=1


##
# Shared resources
##
source "$HOME/.alias"
source "$HOME/.env"
source_if_available "$HOME/.fzf/shell/completion.zsh"
source_if_available "$HOME/.fzf/shell/key-bindings.zsh"


##
# Get notified when someone logs in
##
watch=(notme)                   # watch all logins
logcheck=30                     # every 30 seconds
WATCHFMT="%n from %M has %a tty%l at %T %W"


##
# Local .zshrc
##
source_if_available "$HOME/.zshrc.local"


##
# Pre execution hook
##
function fix_display {
    # Update DISPLAY
    if [ -n "$TMUX" ]; then
        export $(tmux show-environment | grep "^DISPLAY") > /dev/null
    fi
}
add-zsh-hook preexec fix_display


##
# Auto start default tmux session on ssh
##
if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
    tmd
fi
