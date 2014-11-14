# Convenience
alias ls="ls --color=auto --group-directories-first -F -h --time-style=long-iso"
alias lsv="ls --color=auto --group-directories-first -F -h -a -l --time-style=long-iso"
alias df="df -h"
alias ..='cd ..'
alias ...='cd ../..'


# Create a new directory and enter it
function md() {
	mkdir -p "$@" && cd "$@"
}


# ClamAV
alias clamscan="clamscan -ir --exclude-dir=^/sys --exclude-dir=^/dev --exclude-dir=^/proc"
alias clamremove="clamscan -ir --exclude-dir=^/sys --exclude-dir=^/dev --exclude-dir=^/proc --remove=yes"
alias clamupdate="freshclam -v"


# Make sudo use aliases
alias sudo="sudo "


# Gentoo commands
alias esync='eix-sync'
alias eupdate='emerge -uDN --keep-going @world'
alias eupdate_time='emerge -uDNp world | genlop -p'
alias edep='emerge --depclean'
alias eremove='CONFIG_PROTECT="-*" emerge -C'
alias esets="echo '*** Available Sets ***'; emerge --list-sets; echo; echo '*** Installed Custom Sets ***'; eix --print-world-sets"


# Ubuntu commands
#	edep for packages (invoke multiple times)
alias adep='apt-get purge `deborphan`'
#	edep for config files
alias adepconfig='dpkg --purge `dpkg -l | egrep "^rc" | cut -d" " -f3`'
