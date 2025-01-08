## clipboard问题

通过ssh连接到远程服务器，在tmux中使用neovim时无法复制文本到本机系统。

```
# 1) tmux设置
set -s set-clipboard on

# 2) nvim设置

# :h osc52
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

# 可选
set clipboard=unnamedplus
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END

