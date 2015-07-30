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
# Custom keys
##
bindkey "$terminfo[kpp]" history-substring-search-up    # Page Up
bindkey "$terminfo[knp]" history-substring-search-down  # Page Down
bindkey '\e[1;5C' forward-word                          # C-Right
bindkey '\e[1;5D' backward-word                         # C-Left


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

