-- mason_update.lua — headless updater for Mason packages.
--
-- WHY THIS EXISTS
-- `nvim --headless '+MasonUpdate' +qa` never actually updated anything: Mason's
-- registry refresh and package installs are ASYNC jobs, and the `+qa` quit nvim
-- before those jobs finished, so the headless update was a silent no-op (it only
-- appeared to work in the UI because nvim stayed open long enough to finish).
--
-- This script starts the work and BLOCKS with vim.wait() until every install
-- handle closes, then prints a summary. mason.nvim exposes no per-package
-- version-check API in this version, so "update" = reinstall each installed
-- package to the latest version (cheap for already-current ones is not
-- guaranteed — it re-runs the installer, which re-fetches).
--
-- Lives in the nvim config dir (~/.config/nvim -> nvim_dgd), but sits outside
-- lua/ so it is never auto-required — it is only ever run explicitly, headless.
--
-- Run headless (must use -c so init.lua/lazy load first; `nvim -l` runs a
-- minimal mode where mason is unavailable):
--   nvim --headless -c "luafile $HOME/.config/nvim/mason_update.lua" -c qa

-- mason is normally lazy-loaded on a command/filetype; force it in headless.
pcall(function() require('lazy').load({ plugins = { 'mason.nvim' } }) end)

local ok, registry = pcall(require, 'mason-registry')
if not ok then
  io.stderr:write('mason_update: mason-registry not available\n')
  return
end

-- 1) Refresh the registry index so "latest" reflects upstream.
local refreshed = false
registry.refresh(function() refreshed = true end)
vim.wait(60000, function() return refreshed end, 100)

-- 2) Reinstall every installed package to latest, tracking completion.
local pkgs = registry.get_installed_packages()
if #pkgs == 0 then
  print('mason_update: no installed packages')
  return
end

local remaining = #pkgs
local failed = {}
for _, pkg in ipairs(pkgs) do
  local handle = pkg:install()
  if handle and handle.once then
    handle:once('closed', function()
      if not pkg:is_installed() then failed[#failed + 1] = pkg.name end
      remaining = remaining - 1
    end)
  else
    remaining = remaining - 1 -- couldn't get a handle; don't hang on it
  end
end

-- 10 min ceiling for the whole batch.
local done = vim.wait(10 * 60 * 1000, function() return remaining <= 0 end, 500)

print(string.format('mason_update: %d processed, %d failed%s',
  #pkgs, #failed, (#failed > 0 and (' -> ' .. table.concat(failed, ', ')) or '')))
if not done then
  print('mason_update: TIMED OUT with ' .. remaining .. ' still running')
end
