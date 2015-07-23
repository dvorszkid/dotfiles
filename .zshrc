##
# Key bindings
##
# Lookup in /etc/termcap or /etc/terminfo else, you can get the right keycode
# by typing ^v and then type the key or key combination you want to use.
# "man zshzle" for the list of available actions
autoload zkbd
[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
ZKBD_FILE=~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}
[[ ! -f $ZKBD_FILE ]] && zkbd
source $ZKBD_FILE

bindkey -v
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" history-beginning-search-forward
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
bindkey '\e[1;5C' forward-word                      # C-Right
bindkey '\e[1;5D' backward-word                     # C-Left
bindkey '^W'      backward-kill-word
bindkey '^E'      kill-word
bindkey '^Y'      backward-kill-line
bindkey '^U'      kill-line
bindkey '^P'      yank
bindkey '^F'      history-incremental-pattern-search-backward


##
# Colors
##
autoload -U colors
colors          # colors


##
# Open files
##
autoload -U zsh-mime-setup
zsh-mime-setup  # run everything as if it's an executable


##
# History
##
HISTFILE=~/.zsh_history         # where to store zsh config
HISTSIZE=1024                   # big history
SAVEHIST=1024                   # big history
setopt append_history           # append
setopt hist_ignore_all_dups     # no duplicate
setopt hist_ignore_space        # ignore space prefixed commands
setopt hist_reduce_blanks       # trim blanks
setopt hist_verify              # show before executing history commands
setopt inc_append_history       # add commands as they are typed, don't wait until shell exit 
unsetopt share_history          # do not share hist between sessions
setopt bang_hist                # !keyword


##
# Pushd
##
setopt auto_pushd               # make cd push old dir in dir stack
setopt pushd_ignore_dups        # no duplicates in dir stack
setopt pushd_silent             # no dir stack after pushd or popd
setopt pushd_to_home            # `pushd` = `pushd $HOME`


##
# Various
##
setopt auto_cd                  # if command is a path, cd into it
setopt auto_remove_slash        # self explicit
setopt chase_links              # resolve symlinks
setopt correct                  # try to correct spelling of commands
setopt extended_glob            # activate complex pattern globbing
setopt glob_dots                # include dotfiles in globbing
setopt print_exit_value         # print return value if non-zero
setopt nonomatch                # pass the unevaluated argument like bash
unsetopt beep                   # no bell on error
unsetopt bg_nice                # no lower prio for background jobs
unsetopt clobber                # must use >| to truncate existing files
unsetopt hist_beep              # no bell on error in history
unsetopt hup                    # no hup signal at shell exit
unsetopt ignore_eof             # do not exit on end-of-file
unsetopt list_beep              # no bell on ambiguous completion
unsetopt rm_star_silent         # ask for confirmation for `rm *' or `rm path/*'


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


## 
# Antigen (oh-my-zsh)
##
DISABLE_AUTO_UPDATE=true
source $HOME/.local/share/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundles <<EOBUNDLES
git
screen
tmux
vi-mode
z
systemadmin
sudo
zsh_reload
zsh-users/zsh-syntax-highlighting
EOBUNDLES
antigen theme $HOME/.local/share ngg --no-local-clone
antigen apply

