if [ -z "$STARTED_TMUX" ] && [ -n "$SSH_TTY" ]
then
  case $- in
    (*i*)
      STARTED_TMUX=1; export STARTED_TMUX
      tmux-home || echo "Tmux failed! Continuing with normal bash startup."
  esac
fi
