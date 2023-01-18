local wk = require("which-key")
vim.o.timeout = true
vim.o.timeoutlen = 300
wk.setup {
  plugins = {
    marks = false,
    registers = false,
    spelling = { enabled = false, suggestions = 20 },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = false,
      nav = false,
      z = false,
      g = false
    }
  }
}

-- local Terminal = require('toggleterm.terminal').Terminal
-- local toggle_float = function()
--   local float = Terminal:new({ direction = "float" })
--   return float:toggle()
-- end
-- local toggle_lazygit = function()
--   local lazygit = Terminal:new({ cmd = 'lazygit', direction = "float" })
--   return lazygit:toggle()
-- end

local mappings = {
  q = { ":q<cr>", "[q]uit" },
  Q = { ":wq<cr>", "[Q]uit and save" },
  w = { ":w<cr>", "[w]rite/save" },
  -- x = { ":bdelete<cr>", "Close" },
  -- E = { ":e ~/.config/nvim/init.lua<cr>", "Edit config" },
  -- f = { ":Telescope find_files<cr>", "Telescope Find Files" },
  -- r = { ":Telescope live_grep<cr>", "Telescope Live Grep" },
  -- t = {
  --   t = { ":ToggleTerm<cr>", "Split Below" },
  --   f = { toggle_float, "Floating Terminal" },
  --   l = { toggle_lazygit, "LazyGit" }
  -- },
  --
  r = {
    -- TODO: I like these hints - but this should be in the setup for bufexporer, not here
    name = '[r]e[n]ame',
  },
  -- r = {
  --   name = '[r]ails ...',
  --   g = { "<Plug>(rails)gf<cr>", "[g]o to the rails file" },
  -- },
  b = {
    -- TODO: I like these hints - but this should be in the setup for bufexporer, not here
    name = '[b]uffer ...',
  },
    name = '[s]earch ...',
  },
  l = {
    name = "[l]SP ...",
    i = { ":LspInfo<cr>", "[i]info on connected language servers" },
    k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "si[k]gnature help" },
    K = { "<cmd>Lspsaga hover_doc<cr>", "[K]hover commands" },
    w = { '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', "add [w]orkspace folder" },
    W = { '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', "remove [W]orkspace folder" },
    l = {
      '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>',
      "List Workspace Folders"
    },
    t = { '<cmd>lua vim.lsp.buf.type_definition()<cr>', "[t]ype Definition" },
    d = { '<cmd>lua vim.lsp.buf.definition()<cr>', "go to [d]efinition" },
    D = { '<cmd>lua vim.lsp.buf.declaration()<cr>', "go to [D]eclaration" },
    r = { '<cmd>lua vim.lsp.buf.references()<cr>', "[r]eferences" },
    R = { '<cmd>Lspsaga rename<cr>', "[R]ename" },
    a = { '<cmd>Lspsaga code_action<cr>', "code [a]ction" },
    e = { '<cmd>Lspsaga show_line_diagnostics<cr>', "show Lin[e] diagnostics" },
    n = { '<cmd>Lspsaga diagnostic_jump_next<cr>', "go to [n]ext diagnostic" },
    N = { '<cmd>Lspsaga diagnostic_jump_prev<cr>', "go to [N]previous Diagnostic" }
  },
  z = {
    name = "[z]en ...",
    z = { ":ZenMode<cr>", "toggle [z]en Mode" },
    t = { ":Twilight<cr>", "toggle [t]wilight" }
  },
  p = {
    name = "[p]acker ...",
    r = { ":PackerClean<cr>", "[r]emove unused plugins" },
    c = { ":PackerCompile profile=true<cr>", "re[c]ompile plugins" },
    i = { ":PackerInstall<cr>", "[i]nstall plugins" },
    p = { ":PackerProfile<cr>", "[p]rofile" },
    s = { ":PackerSync<cr>", "[s]ync" },
    S = { ":PackerStatus<cr>", "[S]tatus" },
    u = { ":PackerUpdate<cr>", "[u]pdate" }
  }
  t = {
    name = "[t]ypescript and toggle ...",
    a = { ":TypescriptAddMissingImports<cr>", "[t]ypescript [a]dd missing imports" },
    d = { ":TypescriptGoToSourceDefinition<cr>", "[t]ypescript source [d]efinition" },
    l = { ":ToggleAlternate<cr>", "[t]oggle a[l]ternate" },
    o = { ":TypescriptOrganizeImports<cr>", "[t]ypescript [o]rganize" },
    r = { ":TypescriptRemoveUnused<cr>", "[t]ypescript [r]emove unused" }
  },
}

local opts = { prefix = '<leader>' }
wk.register(mappings, opts)

