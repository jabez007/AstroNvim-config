-- Lazygit that carries Neovim along when you switch worktrees inside it.
-- Lazygit writes its final directory to LAZYGIT_NEW_DIR_FILE on quit. When that directory belongs to another
-- worktree of the same repository, clean file buffers move to the same paths there and the global cwd follows.

local uv = vim.uv

-- Git reports resolved paths, so buffer names must be resolved too before comparing prefixes.
local function realpath(path) return uv.fs_realpath(path) or vim.fs.normalize(path) end

--- Find the worktree root and the Git directory shared by all worktrees of the repository.
---@param dir string
---@return string? root, string? common
local function git_location(dir)
  local function rev_parse(...)
    local result = vim.fn.systemlist { "git", "-C", dir, "rev-parse", ... }
    return vim.v.shell_error == 0 and result[1] or nil
  end

  local root = rev_parse "--show-toplevel"
  local common = rev_parse("--path-format=absolute", "--git-common-dir")
  if not root or not common then return end
  return realpath(root), realpath(common)
end

--- Return the path a listed file buffer would have under `new_root`, or nil when it is not under `old_root`.
---@return string?
local function counterpart(buf, old_root, new_root)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" or not vim.bo[buf].buflisted or vim.bo[buf].buftype ~= "" then return end

  local path = realpath(name)
  local prefix = old_root .. "/"
  if not vim.startswith(path, prefix) then return end
  return new_root .. "/" .. path:sub(#prefix + 1)
end

--- Show `buf` in `win` and restore the cursor and scroll position, clamped to the new file's length.
local function show_in_window(win, buf)
  local view = vim.api.nvim_win_call(win, vim.fn.winsaveview)
  if pcall(vim.api.nvim_win_set_buf, win, buf) then
    vim.api.nvim_win_call(win, function() vim.fn.winrestview(view) end)
  end
end

--- Replace `buf` with a buffer for `target` in every window, then delete `buf` once no window shows it.
---@return boolean moved
local function move_buffer(buf, target)
  local wins = vim.fn.win_findbuf(buf)
  local next_buf = vim.fn.bufadd(target)

  -- Hidden buffers stay unloaded until entered, so the switch doesn't start filetype and LSP work for each one.
  if #wins > 0 then
    -- Load before touching windows so a failed read leaves them on the old buffer.
    if not pcall(vim.fn.bufload, next_buf) then return false end
    for _, win in ipairs(wins) do
      show_in_window(win, next_buf)
    end
  end

  vim.bo[next_buf].buflisted = true
  if #vim.fn.win_findbuf(buf) == 0 then pcall(vim.api.nvim_buf_delete, buf, {}) end
  return true
end

--- Move clean file buffers under `old_root` to the same relative paths under `new_root`.
--- Modified buffers stay put so unsaved edits are never lost or written to the wrong worktree.
---@return integer switched, integer dirty, integer missing
local function switch_clean_buffers(old_root, new_root)
  local switched, dirty, missing = 0, 0, 0

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local target = counterpart(buf, old_root, new_root)
    if target then
      local stat = uv.fs_stat(target)
      if vim.bo[buf].modified then
        dirty = dirty + 1
      elseif not stat or stat.type ~= "file" then
        missing = missing + 1
      elseif move_buffer(buf, target) then
        switched = switched + 1
      end
    end
  end

  return switched, dirty, missing
end

--- Follow the directory lazygit recorded on quit when it is a different worktree or repository.
local function follow_lazygit_dir(dir_file, old_root, old_common)
  if vim.fn.filereadable(dir_file) ~= 1 then return end
  local dir = vim.trim(vim.fn.readfile(dir_file)[1] or "")
  vim.fn.delete(dir_file)
  if dir == "" or vim.fn.isdirectory(dir) ~= 1 then return end

  local new_root, new_common = git_location(dir)
  -- Lazygit records a directory on every quit, so an unchanged root means there is nothing to follow.
  if new_root and new_root == old_root then return end

  local switched, dirty, missing = 0, 0, 0
  -- Only worktrees of one repository share a file layout worth remapping.
  if old_root and new_root and old_common == new_common then
    switched, dirty, missing = switch_clean_buffers(old_root, new_root)
  end

  -- Neo-tree's filesystem source follows the cwd by default (bind_to_cwd).
  vim.cmd.cd(vim.fn.fnameescape(dir))

  vim.notify(
    ("Worktree: %s\n%d switched, %d modified, %d missing"):format(new_root or dir, switched, dirty, missing),
    dirty > 0 and vim.log.levels.WARN or vim.log.levels.INFO
  )
end

local function open_lazygit()
  local old_root, old_common = git_location(vim.fn.getcwd())
  local dir_file = vim.fn.tempname()

  -- astrocore caches the terminal by `cmd`, so these options only apply when lazygit starts. A toggle that reopens
  -- a hidden lazygit reuses the first call's file and roots, which belong to that same process.
  require("astrocore").toggle_term_cmd {
    cmd = "lazygit",
    direction = "float",
    env = { LAZYGIT_NEW_DIR_FILE = dir_file },
    on_exit = function()
      vim.schedule(function() follow_lazygit_dir(dir_file, old_root, old_common) end)
    end,
  }
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = {
    mappings = {
      n = {
        -- Both replace AstroNvim's lazygit mappings, which would otherwise run a second, separate lazygit.
        ["<Leader>gg"] = { open_lazygit, desc = "ToggleTerm lazygit (follows worktrees)" },
        ["<Leader>tl"] = { open_lazygit, desc = "ToggleTerm lazygit (follows worktrees)" },
      },
    },
  },
}
