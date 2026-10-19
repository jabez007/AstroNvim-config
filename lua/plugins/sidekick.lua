---@type LazySpec
return {
  {
    "folke/sidekick.nvim",
    cmd = "Sidekick",
    opts = {
      -- CLI assistants work independently of Copilot's next edit suggestions.
      nes = { enabled = false },
      cli = {
        mux = {
          backend = "tmux",
          enabled = vim.fn.executable "tmux" == 1,
        },
      },
    },
    keys = {
      {
        "<Leader>aa",
        function() require("sidekick.cli").toggle { filter = { installed = true } } end,
        desc = "Toggle AI assistant",
      },
      {
        "<Leader>as",
        function() require("sidekick.cli").select { filter = { installed = true } } end,
        desc = "Select AI assistant",
      },
      {
        "<Leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach AI assistant",
      },
      {
        "<Leader>at",
        function() require("sidekick.cli").send { msg = "{this}" } end,
        mode = { "n", "x" },
        desc = "Send cursor or selection location",
      },
      {
        "<Leader>af",
        function() require("sidekick.cli").send { msg = "{file}" } end,
        desc = "Send current file path",
      },
      {
        "<Leader>av",
        function() require("sidekick.cli").send { msg = "{selection}" } end,
        mode = "x",
        desc = "Send selection",
      },
      {
        "<Leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Select AI prompt",
      },
      {
        "<Leader>ax",
        function() require("sidekick.cli").send { prompt = "diagnostics" } end,
        desc = "Send file diagnostics",
      },
      {
        "<Leader>ao",
        function() require("sidekick.cli").toggle { name = "opencode", focus = true } end,
        desc = "Toggle OpenCode",
      },
      {
        "<Leader>ac",
        function() require("sidekick.cli").toggle { name = "claude", focus = true } end,
        desc = "Toggle Claude",
      },
      {
        "<Leader>aC",
        function() require("sidekick.cli").toggle { name = "codex", focus = true } end,
        desc = "Toggle Codex",
      },
    },
  },
  {
    "AstroNvim/astrocore",
    opts = {
      options = { opt = { autoread = true } },
      mappings = {
        n = { ["<Leader>a"] = { desc = "AI assistants" } },
        x = { ["<Leader>a"] = { desc = "AI assistants" } },
      },
    },
  },
  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      picker = {
        actions = {
          sidekick_send = function(...) return require("sidekick.cli.picker.snacks").send(...) end,
        },
        win = {
          input = {
            keys = { ["<M-a>"] = { "sidekick_send", mode = { "n", "i" } } },
          },
        },
      },
    },
  },
}
