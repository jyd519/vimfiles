#!/bin/bash

SESSION="${PWD##*/}"
tmux kill-session -t $SESSION 2>/dev/null

tmux new-session -d -s $SESSION -n "Grid"

# 创建 2x2 网格
# ┌───┬───┐
# │ 0 │ 1 │
# ├───┼───┤
# │ 2 │ 3 │
# └───┴───┘

for i in $(seq 1 3); do
  tmux split-window -h -t $SESSION:0.0
done

tmux select-layout -t $SESSION:0 tiled

# 在每个窗格执行 echo 对应编号
tmux send-keys -t $SESSION:0.0 'echo 1' Enter
tmux send-keys -t $SESSION:0.1 'echo 2' Enter
tmux send-keys -t $SESSION:0.2 'echo 3' Enter
tmux send-keys -t $SESSION:0.3 'echo 4' Enter

# 回到左上窗格并附加会话
tmux select-pane -t $SESSION:0.0
tmux attach -t $SESSION