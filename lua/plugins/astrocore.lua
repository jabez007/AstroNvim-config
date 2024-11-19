--if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- mappings for package-info
        -- https://github.com/vuki656/package-info.nvim?tab=readme-ov-file#%EF%B8%8F-all-keybindings
        ["<Leader>m"] = { desc = "package-info" },
        ["<Leader>ms"] = {
          function() require("package-info").show() end,
          silent = true,
          noremap = true,
          desc = "Show dependency versions",
        },
        ["<Leader>mc"] = {
          function() require("package-info").hide() end,
          silent = true,
          noremap = true,
          desc = "Hide dependency versions",
        },
        ["<Leader>mt"] = {
          function() require("package-info").toggle() end,
          silent = true,
          noremap = true,
          desc = "Toggle dependency versions",
        },
        ["<Leader>mu"] = {
          function() require("package-info").update() end,
          silent = true,
          noremap = true,
          desc = "Update dependency on the line",
        },
        ["<Leader>md"] = {
          function() require("package-info").delete() end,
          silent = true,
          noremap = true,
          desc = "Delete dependency on the line",
        },
        ["<Leader>mi"] = {
          function() require("package-info").install() end,
          silent = true,
          noremap = true,
          desc = "Install a new dependency",
        },
        ["<Leader>mp"] = {
          function() require("package-info").change_version() end,
          silent = true,
          noremap = true,
          desc = "Install a different dependency version",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}
