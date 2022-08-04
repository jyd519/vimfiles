local api = vim.api

buf = api.nvim_create_buf(false, true) 

  -- get dimensions
  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")

  -- calculate our floating window size
  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)

  -- and its starting position
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  -- set some options
  local opts = {
    style = "minimal",
    relative = "win",
    width = win_width,
    height = win_height,
    row = row,
    col = col
  }

api.nvim_open_win(buf, true, opts)
