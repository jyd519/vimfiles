-- treesitter {{{1
local mod = prequire("nvim-treesitter.configs")
if mod then
  mod.setup {
    ensure_installed = {"c", "cpp", "css", "json", "go", "cmake", "html", "javascript", "typescript"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
      enable = true,              -- false will disable the whole extension
      disable = { "godot_resource", "markdown" },  -- list of language that will be disabled
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = true },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "grr",
        },
      },
    },
  }

  vim.cmd([[
  function! SetTreeSitterFolding()
    setlocal foldmethod=expr
    setlocal foldexpr=nvim_treesitter#foldexpr()
  endfunction

  augroup Folding
    au!
    autocmd FileType cpp,c,vim,typescript,lua call SetTreeSitterFolding() 
  augroup END
  ]])
end
