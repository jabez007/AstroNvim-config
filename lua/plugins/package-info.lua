---@type LazySpec
return {
  {
    "vuki656/package-info.nvim",
    -- The TypeScript pack supplies setup, dependencies, and the package.json load event.
    optional = true,
    keys = {
      {
        "<Leader>ms",
        function() require("package-info").show() end,
        silent = true,
        desc = "Show dependency versions",
      },
      {
        "<Leader>mc",
        function() require("package-info").hide() end,
        silent = true,
        desc = "Hide dependency versions",
      },
      {
        "<Leader>mt",
        function() require("package-info").toggle() end,
        silent = true,
        desc = "Toggle dependency versions",
      },
      {
        "<Leader>mu",
        function() require("package-info").update() end,
        silent = true,
        desc = "Update dependency on the line",
      },
      {
        "<Leader>md",
        function() require("package-info").delete() end,
        silent = true,
        desc = "Delete dependency on the line",
      },
      {
        "<Leader>mi",
        function() require("package-info").install() end,
        silent = true,
        desc = "Install a new dependency",
      },
      {
        "<Leader>mp",
        function() require("package-info").change_version() end,
        silent = true,
        desc = "Install a different dependency version",
      },
    },
  },
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = { ["<Leader>m"] = { desc = "package-info" } },
      },
    },
  },
}
