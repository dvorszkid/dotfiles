if [ -z "$STARTED_TMUX" ] && [ -n "$SSH_TTY" ]
then
  case $- in
    (*i*)
      STARTED_STMUX=1; export STARTED_TMUX
      tmux-home || echo "Tmux failed! Continuing with normal bash startup."
  esac
fi
