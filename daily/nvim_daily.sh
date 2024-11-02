#!/usr/local/bin/zsh
source ~/.zshrc

# Run Lazy sync
nvim --headless '+Lazy! sync' +qa

# Run MasonUpdate and wait until it's complete
# nvim --headless -c 'lua require("mason-registry").update(function() vim.cmd("qa") end)'

# Run MasonUpdateAll and wait until it's complete
# nvim --headless -c 'lua require("mason-update-all").update_all_packages(function() vim.cmd("qa") end)'

# nvim --headless '+Lazy! sync' +qa
nvim --headless '+MasonUpdate' +qa
nvim --headless '+MasonUpdateAll' +qa
sleep 10
