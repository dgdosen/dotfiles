-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<C-h>"] = "which_key",
        -- ['<esc>'] = "close",
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'neoclip')
pcall(require('telescope').load_extension, 'ui-select')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, et//
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] fuzzily search in current buffer]' })

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[s]earch [h]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[s]earch [f]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[s]earch Telescope [s]ymbols' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[s]earch current [w]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[s]earch by [g]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[s]earch [r]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[s]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>sso', builtin.lsp_document_symbols, { desc = '[s]earch [s]ymbols in [o]pen file' })
vim.keymap.set('n', '<leader>ssw', builtin.lsp_workspace_symbols, { desc = '[s]earch [s]ymbols in [w]orkspace' })
vim.keymap.set('n', '<leader>ssd', builtin.lsp_dynamic_workspace_symbols,
  { desc = '[s]earch [s]ymbols [d]ynamically in workspace' })
vim.keymap.set('n', '<leader>sst', builtin.treesitter, { desc = '[s]earch [s]ymbols with [t]reesitter (file outline)' })

vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[s]earch [/] in Open Files' })


-- TODO: I can't figure out how to get Telescope search_dirs option to work in a call via vim.keymap.
-- vim.keymap.set('n', '<leader>gm', require('telescope.builtin').find_files({ search_dirs = { "./app/models" }}), { desc = '[G]et [M]odel' })
