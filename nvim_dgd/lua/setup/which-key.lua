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

wk.add({
  { "<leader>Q",  ":wq<cr>",                                                               desc = "[Q]uit and save" },
  { "<leader>b",  group = "[b]uffer ..." },
  { "<leader>k",  group = "spell chec[k] ..." },
  { "<leader>ka", "1z=",                                                                   desc = "spell chec[k] [a]ccept first" },
  { "<leader>kn", "]s",                                                                    desc = "spell chec[k] [n]ext" },
  { "<leader>kp", "[s",                                                                    desc = "spell chec[k] [p]revious" },
  { "<leader>ks", "z=",                                                                    desc = "spell chec[k] [s]uggest" },
  { "<leader>kt", ":set spell!<cr>",                                                       desc = "spell chec[k] [t]oggle" },
  { "<leader>l",  group = "[l]SP ..." },
  { "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<cr>",                                desc = "go to [D]eclaration" },
  { "<leader>lK", "<cmd>Lspsaga hover_doc<cr>",                                            desc = "[K]hover commands" },
  { "<leader>lN", "<cmd>Lspsaga diagnostic_jump_prev<cr>",                                 desc = "go to [N]previous Diagnostic" },
  { "<leader>lR", "<cmd>Lspsaga rename<cr>",                                               desc = "[R]ename" },
  { "<leader>lW", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>",                    desc = "remove [W]orkspace folder" },
  { "<leader>la", "<cmd>Lspsaga code_action<cr>",                                          desc = "code [a]ction" },
  { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>",                                 desc = "go to [d]efinition" },
  { "<leader>le", "<cmd>Lspsaga show_line_diagnostics<cr>",                                desc = "show Lin[e] diagnostics" },
  { "<leader>li", ":LspInfo<cr>",                                                          desc = "[i]info on connected language servers" },
  { "<leader>lk", "<cmd>lua vim.lsp.buf.signature_help()<cr>",                             desc = "si[k]gnature help" },
  { "<leader>ll", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", desc = "List Workspace Folders" },
  { "<leader>ln", "<cmd>Lspsaga diagnostic_jump_next<cr>",                                 desc = "go to [n]ext diagnostic" },
  { "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>",                                 desc = "[r]eferences" },
  { "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<cr>",                            desc = "[t]ype Definition" },
  { "<leader>lw", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>",                       desc = "add [w]orkspace folder" },
  { "<leader>m",  group = "[m]arkup ..." },
  { "<leader>mx", ":%!xmllint --format -<CR>",                                             desc = "[x]ml format" },
  { "<leader>p",  group = "[p]lugins ..." },
  { "<leader>pS", ":Lazy health<cr>",                                                      desc = "[S]? health" },
  { "<leader>pc", ":Lazy clean<cr>",                                                       desc = "[c]lean plugins" },
  { "<leader>pi", ":Lazy install<cr>",                                                     desc = "[i]nstall plugins" },
  { "<leader>pp", ":Lazy profile<cr>",                                                     desc = "[p]rofile" },
  { "<leader>ps", ":Lazy sync<cr>",                                                        desc = "[s]ync" },
  { "<leader>pu", ":Lazy update<cr>",                                                      desc = "[u]pdate" },
  { "<leader>q",  ":q<cr>",                                                                desc = "[q]uit" },
  { "<leader>r",  group = "[r]e[n]ame" },
  { "<leader>s",  group = "[s]earch ..." },
  { "<leader>sy", group = "rub[y] ..." },
  { "<leader>t",  group = "[t]ypescript and toggle ..." },
  { "<leader>ta", ":TypescriptAddMissingImports<cr>",                                      desc = "[t]ypescript [a]dd missing imports" },
  { "<leader>td", ":TypescriptGoToSourceDefinition<cr>",                                   desc = "[t]ypescript source [d]efinition" },
  { "<leader>tl", ":ToggleAlternate<cr>",                                                  desc = "[t]oggle a[l]ternate" },
  { "<leader>to", ":TypescriptOrganizeImports<cr>",                                        desc = "[t]ypescript [o]rganize" },
  { "<leader>tr", ":TypescriptRemoveUnused<cr>",                                           desc = "[t]ypescript [r]emove unused" },
  { "<leader>w",  ":w<cr>",                                                                desc = "[w]rite/save" },
  { "<leader>z",  group = "[z]en ..." },
  { "<leader>zt", ":Twilight<cr>",                                                         desc = "toggle [t]wilight" },
  { "<leader>zz", ":ZenMode<cr>",                                                          desc = "toggle [z]en Mode" },
})




-- {
--   q = { ":q<cr>", "[q]uit" },
--   Q = { ":wq<cr>", "[Q]uit and save" },
--   w = { ":w<cr>", "[w]rite/save" },
--   -- x = { ":bdelete<cr>", "Close" },
--   -- E = { ":e ~/.config/nvim/init.lua<cr>", "Edit config" },
--   -- f = { ":Telescope find_files<cr>", "Telescope Find Files" },
--   -- r = { ":Telescope live_grep<cr>", "Telescope Live Grep" },
--   -- t = {
--   --   t = { ":ToggleTerm<cr>", "Split Below" },
--   --   f = { toggle_float, "Floating Terminal" },
--   --   l = { toggle_lazygit, "LazyGit" }
--   -- },
--   --
--   r = {
--     -- TODO: I like these hints - but this should be in the setup for bufexporer, not here
--     name = '[r]e[n]ame',
--   },
--   -- r = {
--   --   name = '[r]ails ...',
--   --   g = { "<Plug>(rails)gf<cr>", "[g]o to the rails file" },
--   -- },
--   b = {
--     -- TODO: I like these hints - but this should be in the setup for bufexporer, not here
--     name = '[b]uffer ...',
--   },
--   k = {
--     name = "spell chec[k] ...",
--     t = { ":set spell!<cr>", "spell chec[k] [t]oggle" },
--     n = { "]s", "spell chec[k] [n]ext" },
--     p = { "[s", "spell chec[k] [p]revious" },
--     a = { "1z=", "spell chec[k] [a]ccept first" },
--     s = { "z=", "spell chec[k] [s]uggest" },
--   },
--   l = {
--     name = "[l]SP ...",
--     i = { ":LspInfo<cr>", "[i]info on connected language servers" },
--     k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "si[k]gnature help" },
--     K = { "<cmd>Lspsaga hover_doc<cr>", "[K]hover commands" },
--     w = { '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', "add [w]orkspace folder" },
--     W = { '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', "remove [W]orkspace folder" },
--     l = {
--       '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>',
--       "List Workspace Folders"
--     },
--     t = { '<cmd>lua vim.lsp.buf.type_definition()<cr>', "[t]ype Definition" },
--     d = { '<cmd>lua vim.lsp.buf.definition()<cr>', "go to [d]efinition" },
--     D = { '<cmd>lua vim.lsp.buf.declaration()<cr>', "go to [D]eclaration" },
--     r = { '<cmd>lua vim.lsp.buf.references()<cr>', "[r]eferences" },
--     R = { '<cmd>Lspsaga rename<cr>', "[R]ename" },
--     a = { '<cmd>Lspsaga code_action<cr>', "code [a]ction" },
--     e = { '<cmd>Lspsaga show_line_diagnostics<cr>', "show Lin[e] diagnostics" },
--     n = { '<cmd>Lspsaga diagnostic_jump_next<cr>', "go to [n]ext diagnostic" },
--     N = { '<cmd>Lspsaga diagnostic_jump_prev<cr>', "go to [N]previous Diagnostic" }
--   },
--   p = {
--     name = "[p]lugins ...",
--     c = { ":Lazy clean<cr>", "[c]lean plugins" },
--     S = { ":Lazy health<cr>", "[S]? health" },
--     i = { ":Lazy install<cr>", "[i]nstall plugins" },
--     p = { ":Lazy profile<cr>", "[p]rofile" },
--     s = { ":Lazy sync<cr>", "[s]ync" },
--     u = { ":Lazy update<cr>", "[u]pdate" }
--   },
--   s = {
--     name = "[s]earch ...",
--     y = {
--       name = "rub[y] ..."
--     }
--   },
--   t = {
--     name = "[t]ypescript and toggle ...",
--     a = { ":TypescriptAddMissingImports<cr>", "[t]ypescript [a]dd missing imports" },
--     d = { ":TypescriptGoToSourceDefinition<cr>", "[t]ypescript source [d]efinition" },
--     l = { ":ToggleAlternate<cr>", "[t]oggle a[l]ternate" },
--     o = { ":TypescriptOrganizeImports<cr>", "[t]ypescript [o]rganize" },
--     r = { ":TypescriptRemoveUnused<cr>", "[t]ypescript [r]emove unused" }
--   },
--   z = {
--     name = "[z]en ...",
--     z = { ":ZenMode<cr>", "toggle [z]en Mode" },
--     t = { ":Twilight<cr>", "toggle [t]wilight" }
--   },
-- }
