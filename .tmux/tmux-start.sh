tmux new-session -d -s $1 
tmux send-keys -t $1 "c $1" C-m
tmux send-keys 'vim' C-m
tmux split-window -h
tmux send-keys -t $1 "c $1" C-m
tmux send-keys 'zeus start' C-m
tmux resize-pane -R 20
tmux splitw -v 
tmux resize-pane -U 17
tmux send-keys -t $1 "c $1" C-m
tmux send-keys 'zeus s' C-m
tmux splitw -v
tmux send-keys -t $1 "c $1" C-m
tmux send-keys 'guard' C-m
tmux select-pane -L 
tmux attach-session -d


