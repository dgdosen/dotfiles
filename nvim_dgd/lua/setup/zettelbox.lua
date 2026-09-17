-- Zettelbox: draft notes locally in ~/dev/zettelbox, flush into Bear.app via bearcli.
-- The full buffer is piped to `bearcli create` on stdin; Bear derives the title
-- from the first line. Local file is deleted only after bearcli exits 0.

local M = {}

local INBOX  = vim.fn.expand("~/dev/zettelbox")
local BEARCLI = "/Applications/Bear.app/Contents/MacOS/bearcli"
local TAGS   = "inbox/scratch"

function M.new_draft()
  vim.fn.mkdir(INBOX, "p")
  local stamp = os.date("%Y-%m-%d-%H%M%S")
  local path = INBOX .. "/" .. stamp .. ".md"
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

function M.send_to_bear()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if #lines == 0 or (#lines == 1 and lines[1] == "") then
    vim.notify("Bear: buffer is empty", vim.log.levels.WARN)
    return
  end

  local stderr_lines = {}
  local job = vim.fn.jobstart({ BEARCLI, "create", "--tags", TAGS, "--fields", "title" }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stderr = function(_, data)
      if data then for _, l in ipairs(data) do if l ~= "" then table.insert(stderr_lines, l) end end end
    end,
    on_stdout = function(_, data)
      if data and data[1] and data[1] ~= "" then
        M._last_title = data[1]
      end
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        if code ~= 0 then
          local msg = "Bear: bearcli exit " .. code
          if #stderr_lines > 0 then msg = msg .. " — " .. table.concat(stderr_lines, " | ") end
          vim.notify(msg, vim.log.levels.ERROR)
          return
        end
        local title = M._last_title or "note"
        vim.notify("Bear: sent “" .. title .. "”")
        if path ~= "" and path:find(INBOX, 1, true) == 1 then
          vim.fn.delete(path)
        end
        vim.api.nvim_buf_delete(buf, { force = true })
      end)
    end,
  })

  if job <= 0 then
    vim.notify("Bear: failed to launch bearcli", vim.log.levels.ERROR)
    return
  end
  vim.fn.chansend(job, table.concat(lines, "\n"))
  vim.fn.chanclose(job, "stdin")
end

return M
