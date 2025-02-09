vim.api.nvim_create_user_command("AIConfig", function(args)
  if #args.fargs == 0 then print(vim.inspect(config.opts)) end
  for _, v in pairs(args.fargs) do
    if v == "proxy" then
      config.adapters.opts["proxy"] = vim.g.proxy
      print("codecompanion: ", config.adapters.opts["proxy"])
    end
    if v == "noproxy" then config.adapters.opts["proxy"] = nil end
    if v == "zh" then config.opts.language = "Chinese" end
    if v == "en" then config.opts.language = "English" end
  end
end, {
  nargs = "*",
  desc = "Config codecompanion: proxy, language",
  complete = function() return { "proxy", "noproxy", "zh", "en" } end,
})