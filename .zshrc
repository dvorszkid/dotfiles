##
# zgen
##
source "${HOME}/.local/share/zgen/zgen.zsh"

if ! zgen saved; then
    echo "Creating .zgen/init.zsh ..."

    # bulk load
    zgen loadall <<EOPLUGINS
		radhermit/gentoo-zsh-completions src
EOPLUGINS

    # save all to init script
    zgen save
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
bindkey "$terminfo[kpp]" history-substring-search-up
bindkey "$terminfo[knp]" history-substring-search-down


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

