-- The same as before, but this time we want to generate the file names 
-- based on the file we are currently editing instead of passing them as commandline args

function convert()
  -- cut off the `.md` part of the file
  local destinationFile = vim.fn.expand('%:t:r')
  -- the name of the file you're editing
  local sourceFile = api.nvim_buf_get_name(0)
  spawn('pandoc', {
    args = {sourceFile, '--from', 'gfm', '--to', 'html5', '-o', string.format('%s.html', destinationFile), '-s', '--highlight-style', 'tango'},
  }, 
  {stdout = function()end, stderr = function(data) print(data) end},
  function(code) -- we want to call this function when the process is done
    print('child process exited with code ' .. string.format('%d', code))
  end)
end

function spawn(cmd, opts, input, onexit)
  local handle, pid
  -- open an new pipe for stdout
  local stdout = vim.loop.new_pipe(false)
  -- open an new pipe for stderr
  local stderr = vim.loop.new_pipe(false)
  handle, pid = vim.loop.spawn(cmd, vim.tbl_extend("force", opts, {stdio = {stdout; stderr;}}), 
  function(code, signal)
    -- call the exit callback with the code and signal
    onexit(code, signal)
    -- stop reading data to stdout
    vim.loop.read_stop(stdout)
    -- stop reading data to stderr
    vim.loop.read_stop(stderr)
    -- safely shutdown child process
    safe_close(handle)
    -- safely shutdown stdout pipe
    safe_close(stdout)
    -- safely shutdown stderr pipe
    safe_close(stderr)
  end)
  -- read child process output to stdout
  vim.loop.read_start(stdout, input.stdout)
  -- read child process output to stderr
  vim.loop.read_start(stderr, input.stderr)
end

function safe_close(handle)
  if not vim.loop.is_closing(handle) then
    vim.loop.close(handle)
  end
end