##
# zgen
##
source "${HOME}/.local/share/zgen/zgen.zsh"

# Load zsh plugins
load-zgen-plugins()
{
	# bulk load
	zgen loadall <<EOPLUGINS
		radhermit/gentoo-zsh-completions src
		t413/zsh-background-notify
EOPLUGINS

	# save all to init script
	zgen save
}

# Load zgen if it was never loaded
if ! zgen saved; then
	echo "Initializing zgen ..."
	load-zgen-plugins
fi

# Reload zgen if .zshrc is newer than init.zsh
if [ $(stat -c %Y "${HOME}/$(readlink ~/.zshrc)") -gt $(stat -c %Y "${HOME}/.zgen/init.zsh") ]; then
	echo "Refreshing zgen due to .zshrc update ..."
	load-zgen-plugins
fi


##
# Prezto
##
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


##
# Custom options
##
setopt nonomatch # pass the unevaluated argument like bash


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

