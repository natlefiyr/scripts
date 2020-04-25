#!/bin/bash

function select_all_windows {

  # Notate which window/pane we were originally at
  ORIG_WINDOW_INDEX=`tmux display-message -p '#I'`
  ORIG_PANE_INDEX=`tmux display-message -p '#P'`

  # Count how many windows we have
  windows=$((`tmux list-windows | wc -l` - 1))

  # Loop through the windows
  for (( window=0; window <= $windows; window++ )); do
    tmux select-window -t $window #select the window
  done

  tmux select-window -t $ORIG_WINDOW_INDEX #select the original window
  tmux select-pane -t $ORIG_PANE_INDEX #select the original pane
}
