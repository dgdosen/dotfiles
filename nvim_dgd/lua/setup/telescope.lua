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
-- hidden = true so dot-folders in this dotfiles repo (.config, .zsh_customizations,
-- etc.) are searchable. Still respects .gitignore (no_ignore stays false), so
-- gitignored junk like node_modules is NOT surfaced. Use <leader>sG-style
-- no_ignore only for the rare full sweep.
vim.keymap.set('n', '<leader>sf', function()
  builtin.find_files { hidden = true }
end, { desc = '[s]earch [f]iles' })
-- Full sweep: also ignore .gitignore, so gitignored paths (node_modules, build
-- dirs, etc.) show up too. Counterpart to <leader>sG for grep.
vim.keymap.set('n', '<leader>sF', function()
  builtin.find_files { hidden = true, no_ignore = true }
end, { desc = '[s]earch [F]iles (incl. gitignored)' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[s]earch Telescope [s]ymbols' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[s]earch current [w]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[s]earch by [g]rep' })
vim.keymap.set('n', '<leader>sG', function()
  builtin.live_grep { additional_args = { '--no-ignore', '--hidden' } }
end, { desc = '[s]earch by [G]rep (include ignored/hidden)' })
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
