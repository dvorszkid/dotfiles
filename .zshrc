# MacOS auto completion fix
if command -v brew > /dev/null; then
    fpath+=$(brew --prefix)/share/zsh/site-functions
fi

# zgenom plugin manager
#   https://github.com/jandamm/zgenom
source "${HOME}/.local/share/zgenom/zgenom.zsh"

# Check for plugin and zgenom updates every 7 days
# This does not increase the startup time.
zgenom autoupdate

# Autoreload if .zshrc has changed
ZGEN_RESET_ON_CHANGE=("$(realpath ~/.zshrc)" "$(realpath ~/.alias)" "$(realpath ~/.env)")

# Load zgenom
if ! zgenom saved; then
	# Set case-sensitivity for completion, history lookup, etc.
	zgenom prezto '*:*' case-sensitive 'no'

	# Color output (auto set to 'no' on dumb terminals)
	zgenom prezto '*:*' color 'yes'

	# Set the key mapping style to 'emacs' or 'vi'
	zgenom prezto editor key-bindings 'vi'

	# Do not auto convert .... to ../..
	zgenom prezto editor dot-expansion 'no'

	# Ignore submodules when they are 'dirty', 'untracked', 'all', or 'none'
	zgenom prezto git:status:ignore submodules 'all'

	# Auto set the tab and window titles
	zgenom prezto terminal auto-title 'yes'

	# Set the Prezto modules to load (the order matters)
	ZGEN_PREZTO_LOAD_DEFAULT=0
	zgenom prezto
	zgenom prezto archive
	zgenom prezto environment
	zgenom prezto terminal
	zgenom prezto editor
	zgenom prezto history
	zgenom prezto directory
	zgenom prezto completion
	zgenom prezto prompt
	zgenom prezto git
	zgenom prezto syntax-highlighting
	zgenom prezto history-substring-search

	# Other plugins
	zgenom load gentoo/gentoo-zsh-completions src
	zgenom load t413/zsh-background-notify
	zgenom load dvorszkid/zsh-prompt-cylon
	zgenom load zsh-users/zsh-completions

	# Custom theme
	zgenom prezto prompt theme 'cylon'

	# Save all to init script
	zgenom save

	# Compile your zsh files
	zgenom compile "$HOME/.zshrc"
fi


##
# Custom options
##
setopt nonomatch # pass the unevaluated argument like bash
setopt print_exit_value
unsetopt rm_star_silent
setopt inc_append_history       # Appends every command to the history file once it is executed
unsetopt share_history          # Does NOT reload the history whenever you use it
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

# Alt + arrows to navigate words (Mac)
bindkey -M viins "^[[1;3D" backward-word
bindkey -M viins "^[[1;3C" forward-word


##
# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
##
KEYTIMEOUT=1


##
# Shared resources
##
source "$HOME/.alias"
source "$HOME/.env"


##
# FZF integration
##
if [ -x "$(command -v fzf)" ]
then
  HOMEBREW_INSTALL_PATH=$(dirname $(dirname $(readlink -f $(which fzf))))
  source_if_available "$HOMEBREW_INSTALL_PATH/shell/completion.zsh"
  source_if_available "$HOMEBREW_INSTALL_PATH/shell/key-bindings.zsh"
  source_if_available "/usr/share/fzf/key-bindings.zsh"
  source_if_available "/usr/share/zsh/site-functions/_fzf"
fi


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
# DirEnv: auto load '.envrc' project files
##
if command -v direnv &> /dev/null
then
    eval "$(direnv hook zsh)"
fi


##
# Zoxide zsh integration
##
if command -v zoxide &> /dev/null
then
    eval "$(zoxide init zsh)"
fi


##
# Automatic session name for git repos
##
function update_tmux_session
{
	tmux_session=$(tmux display-message -p '#S')
	if [ "$(echo $tmux_session | cut -d ' ' -f 1)" != "git" ]; then
		return
	fi

	discard=$(git rev-parse --abbrev-ref HEAD 2>&1)
	if [ $? -ne 0 ]; then
		 return
	fi

	git_head=$(git-branch-current 2>&1)
	if [ -z "$git_head" ]; then
		git_head=$(git name-rev --tags --name-only $(git rev-parse HEAD) 2>&1)
	fi
	if [ -z "$git_head" ]; then
		return
	fi

    git_repo=$(pwd | awk -F '/git/' '{ print $2 }' | cut -d '/' -f 1)
	git_head=$(echo $git_head | sed 's/\./-/g')
    tmux rename-session -t "$tmux_session" "$(echo git - $git_repo \($git_head\))"
}

if [ -z "$MC_SID" ] && [ -n "$TMUX" ]; then
    add-zsh-hook precmd update_tmux_session
fi


##
# Auto start default tmux session on ssh
##
if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
    tmd
fi
