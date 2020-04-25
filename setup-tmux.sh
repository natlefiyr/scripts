#!/bin/bash

function command_in_window_pane {
	window=$1
	pane=$2
	command="$3"
	tmux select-window -t $window #select the pane
	tmux select-pane -t $pane #select the pane
	# Sleep (may need to change this approach, see backup files)
	sleep .2
	# temp suspend any gui that's running
	tmux send-keys C-z
	# if no gui was running, remove the escape sequence we just sent ^Z
	tmux send-keys C-H
	# Note: it will complain that it doesn't recognize C-m, but it enters a newline
	# ensure aliases are recognized
	tmux send-keys "shopt -s expand_aliases;" C-m
	# load my aliases
	tmux send-keys "source ~/.bashrc;" C-m
	# run the command & switch back to the gui if there was any
	tmux send-keys "$command && fg 2>/dev/null" C-m
}

function send_command_and_return {
	# Notate which window/pane we were originally at
	ORIG_WINDOW_INDEX=`tmux display-message -p '#I'`
	ORIG_PANE_INDEX=`tmux display-message -p '#P'`

	command_in_window_pane "$@"

	# Return to the original window/pane
	tmux select-window -t $ORIG_WINDOW_INDEX #select the original window
	tmux select-pane -t $ORIG_PANE_INDEX #select the original pane
}

# Kills all but the 1st window
function kill_all_windows {
	windows=$((`tmux list-windows | wc -l` - 1))

	# Loop through the windows
	for (( window=1; window <= $windows; window++ )); do
		tmux kill-window -t $window #kill the window
	done
}

#send_command_and_return bkrd 0 "echo 'hi'"
function setup_tmux {
	tmux rename-window 'bkrd';
#	send_command_and_return bkrd 0 "fsu; hrr feature"
	
	tmux new-window;
	tmux rename-window 'err';
	send_command_and_return err 0 "goerr"
	tmux new-window;
	tmux rename-window 'vim';
	tmux new-window;
	tmux rename-window 'bash';
	tmux new-window;
	# TODO: setup appropriate repl session?
	tmux rename-window 'repl';
	tmux new-window;
	# TODO: setup appropriate sql session?
	tmux rename-window 'sql';
	tmux new-window;
	tmux rename-window 'bash2';
	tmux new-window;
	tmux rename-window 'verify';
	tmux new-window;
	tmux rename-window 'test';
	
	# Wipe off the window highlighting by selecting the windows
	sleep 1
	tmux select-window -t bkrd;
	tmux select-window -t err;
	tmux select-window -t:2;
}
setup_tmux

