tmux new-session -d -s $1

tmux send-keys -t $1 "c $1" C-m
tmux send-keys 'vim' C-m

tmux split-window -h -p 30
tmux send-keys -t $1 "c $1" C-m
tmux send-keys 'zeus start' C-m

tmux splitw -v -p 90
tmux send-keys -t $1 "c $1" C-m
tmux send-keys 'rails s' C-m

tmux splitw -v -p 66
tmux send-keys -t $1 "c $1" C-m
tmux send-keys 'guard' C-m

tmux splitw -v
tmux send-keys -t $1 "c $1" C-m
tmux send-keys 'karma start spec/karma/config/karma.conf.js' C-m

tmux select-pane -L
tmux attach-session -d
