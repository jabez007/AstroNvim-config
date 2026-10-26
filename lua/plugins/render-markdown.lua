---@type LazySpec
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- The community spec supplies the filetype load event and the html and markdown parsers.
    optional = true,
    opts = {
      -- Serves checkbox and callout completions through blink.cmp's LSP source.
      completions = { lsp = { enabled = true } },
    },
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      -- Frontmatter rendering needs the yaml parser, which the Docker pack also installs.
      treesitter = { ensure_installed = { "yaml" } },
      autocmds = {
        markdown_wrap = {
          {
            event = "FileType",
            pattern = "markdown",
            desc = "Wrap markdown prose at word boundaries",
            -- astrocore.lua turns wrap off globally, which leaves long paragraphs on one screen line.
            callback = function()
              vim.opt_local.wrap = true
              vim.opt_local.linebreak = true
            end,
          },
        },
      },
    },
  },
}
