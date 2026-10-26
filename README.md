# AstroNvim config

Personal [AstroNvim v6](https://github.com/AstroNvim/AstroNvim) configuration with
language packs for Bash, Docker, Fish, Go, Lua, Python, TypeScript, and Vue.
The leader key is Space. AI assistants use
[Sidekick](https://github.com/folke/sidekick.nvim), and Markdown buffers render
with [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim).

- [Installation](#installation)
- [Community packs](#community-packs)
- [Package-info](#package-info)
- [Render-markdown](#render-markdown)
- [Sidekick](#sidekick)
- [Maintenance](#maintenance)
- [Configuration](#configuration)

## Installation

### Requirements

- Neovim 0.11.2 or newer, which satisfies both AstroNvim v6 and Sidekick.
- Git, a C compiler, and the Tree-sitter CLI for plugin and parser installation.
  AstroNvim can install the Tree-sitter CLI through Mason.
- Node.js and npm for language servers distributed through npm.
- The runtimes needed by your projects, such as Go, Python, Fish, or Deno.
- Optional tools: ripgrep for project search, a clipboard provider for system
  clipboard access, and a Nerd Font for icons.

See the [AstroNvim requirements](https://docs.astronvim.com/#-installation)
for platform-specific dependencies.

### Back up an existing installation

The upstream template starts with backups of your config, plugins, state, and
cache. Close Neovim before moving these directories. Run the commands for
directories that exist, using unused backup names:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### Create your own repository

To maintain your own version, fork this repository. For a fresh AstroNvim config,
use the **Use this template** button on the
[upstream template](https://github.com/AstroNvim/template).

### Clone the repository

To install this configuration:

```sh
git clone https://github.com/jabez007/AstroNvim-config.git ~/.config/nvim
```

If you created your own repository, substitute its URL in the command above.

### Start Neovim

```sh
nvim
```

The first launch downloads plugins, language tools, and parsers. Allow those
installations to finish, then restart Neovim. Use `:Mason` to inspect language
tools and `:checkhealth` to check the installation.

### Try a checkout alongside your existing config

Run the following from this repository's root:

```sh
XDG_CONFIG_HOME="$(dirname "$PWD")" NVIM_APPNAME="$(basename "$PWD")" nvim
```

This uses the checkout as the config directory and separate data, state, and
cache directories named after the repository. The first launch installs a
separate set of plugins and tools.

## Community packs

[lua/community.lua](lua/community.lua) enables the eight packs below. Docker
also imports YAML support, and the TypeScript/Deno pack imports JSON support.
Java is commented out and is not enabled.

Mason manages the packs' language servers, debuggers, and supported tools.
Project runtimes still need to be on your `PATH`. The descriptions below follow
the installed pack specifications. Follow each pack's source link to inspect
its upstream configuration.

These AstroNvim mappings work across languages when the corresponding server
or debugger supports them:

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `Space la` | Show code actions |
| `Space lf` | Format the buffer or visual selection with an available formatter |
| `Space lR` | Rename a symbol |
| `Space db` | Toggle a breakpoint |
| `Space dc` | Start or continue debugging |

Packs can also configure optional plugins, such as Conform, nvim-lint, and
Neotest. Those integrations require enabling the corresponding plugin separately.
This setup uses AstroNvim's None-ls integration for external formatters and linters.

### Bash

Import: `astrocommunity.pack.bash`.
[Pack source](https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/bash).

Adds the Bash parser, `bashls` language server, `shfmt`, ShellCheck, and the
Bash debug adapter. The server attaches to `sh`, `bash`, and `zsh` filetypes,
with experimental support for Zsh.

Open a shell script to use completion and diagnostics. Use `Space lf` for
formatting and `Space db` followed by `Space dc` for a debugging session.

### Docker

Import: `astrocommunity.pack.docker`.
[Pack source](https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/docker).

Adds the Dockerfile parser, `docker-language-server`, and Hadolint diagnostics.
It also imports the YAML pack and recognizes `docker-compose.yaml` as
`yaml.docker-compose`.

Open a Dockerfile for completion and lint diagnostics, or a Compose file for
YAML support. Running containers still requires your own Docker installation.

### Fish

Import: `astrocommunity.pack.fish`.
[Pack source](https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/fish).

Adds the Fish parser, `fish_indent` formatting, and Fish syntax diagnostics
through None-ls. Install Fish separately so `fish` and `fish_indent` are on
your `PATH`.

Open a `.fish` file and use `Space lf` to format it.

### Go

Import: `astrocommunity.pack.go`.
[Pack source](https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/go).

Requires `go` on your `PATH`. Adds parsers for Go, `go.mod`, `go.sum`, and
`go.work`, plus `gopls` with gofumpt formatting and staticcheck analysis.
Mason installs Delve, `goimports`, `gomodifytags`, `gotests`, `iferr`, and `impl`.
The pack includes `gopher.nvim` and `nvim-dap-go`.

In a Go buffer, use `:GoTestAdd` to generate a test for the function under the
cursor, `:GoTagAdd json` to add struct tags, and `:GoMod tidy` to tidy the module.
Use `Space db` and `Space dc` for Delve debugging. Run `:checkhealth gopher`
if a Go helper command cannot find its tool.

### Lua

Import: `astrocommunity.pack.lua`.
[Pack source](https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/lua).

Adds Lua and Lua-pattern parsers, the `lua_ls` language server, StyLua formatting,
and Selene linting. Selene runs only in projects with a `selene.toml` file and
is skipped on `aarch64` machines.

Use `Space lf` while editing this config to apply [.stylua.toml](.stylua.toml).
The repository's [selene.toml](selene.toml) and [neovim.yml](neovim.yml) configure
linting for Neovim's Lua globals.

### Python

Import: `astrocommunity.pack.python`.
[Pack source](https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/python).

Requires Python available as `python` on your `PATH`. The default pack imports
the Python base, BasedPyright, Black, and isort subpacks. It adds Python and TOML
parsers, BasedPyright analysis and completion, and `debugpy` through `nvim-dap-python`.

The base pack includes `venv-selector.nvim` when `fd`, `fdfind`, or `fd-find` is
available. In a Python buffer, `Space lv` or `:VenvSelect` selects an environment.
Activate the project's environment before launching Neovim if the selector is
unavailable. Use `Space db` and `Space dc` for Python debugging.

Mason automatically registers installed Black and isort with None-ls for
formatting. Use `Space lf` to format a Python buffer and `:NullLsInfo` to inspect
the active sources. Ruff is an optional subpack and is not imported here.

### TypeScript and Deno

Import: `astrocommunity.pack.typescript-all-in-one`.
[Pack source](https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/typescript-all-in-one).

Combines the TypeScript and Deno packs, with JavaScript, TypeScript, TSX, JSDoc,
and JSON parsers. It configures `vtsls` for TypeScript projects and `denols`
through `deno-nvim` for Deno projects, with logic to avoid attaching both servers
to the same buffer. Deno projects use `deno.json` or `deno.jsonc`.

Use Node.js and your project's package manager for Node projects, or install
Deno for Deno projects. The pack includes the JavaScript debug adapter,
`nvim-vtsls`, `tsc.nvim`, and `package-info.nvim`.

Use `gs` to jump to a TypeScript source definition and `:TSC` to run the project's
TypeScript compiler. See [Package-info](#package-info) for dependency commands
in `package.json`.

### Vue

Import: `astrocommunity.pack.vue`.
[Pack source](https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/vue).

Imports the TypeScript pack and adds the Vue parser and Vue language server.
It connects `vtsls` to the Vue TypeScript plugin so `.vue` files receive
TypeScript support alongside Vue language features. It also includes the
JavaScript debug adapter.

Open Neovim from your Vue project's root, with the project's Node dependencies
installed. Use the standard LSP mappings in `.vue` files. The shared TypeScript
pack is reused when both Vue and TypeScript/Deno are imported.

### YAML

Imported through Docker as `astrocommunity.pack.yaml`.
[Pack source](https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/yaml).

Adds the YAML parser, `yamlls`, and SchemaStore schemas for validation and
completion in YAML files, including supported project configuration formats.

### JSON

Imported through TypeScript/Deno as `astrocommunity.pack.json`.
[Pack source](https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/pack/json).

Adds the JSON parser, `jsonls`, and SchemaStore schemas. JSON validation is
enabled, including schema-based checks for recognized configuration files.

## Package-info

[package-info.nvim](https://github.com/vuki656/package-info.nvim) displays the
latest dependency versions in `package.json` and runs package manager commands
from the editor. The shared TypeScript pack, imported by both TypeScript/Deno
and Vue, supplies the plugin, its Nui dependency, and default setup.

The shortcuts and which-key group live in
[lua/plugins/package-info.lua](lua/plugins/package-info.lua). The plugin loads
when you open an existing `package.json` or use one of its shortcuts. Version
annotations appear automatically with the default `autostart = true` setting.
Add an `opts` table to the package-info spec in that file to change plugin options.

Install Node.js and npm, plus your project's package manager if different.
Package-info detects npm, Yarn, pnpm, or Bun from lockfiles and falls back to
npm. These executables must be on Neovim's `PATH`.

Use these normal-mode shortcuts in a saved, valid `package.json`. For update,
delete, and version selection, place the cursor on the dependency's line.
Those actions and installation run the package manager and can change
`package.json`, the lockfile, and installed dependencies.

| Key | Action |
| --- | --- |
| `Space ms` | Show dependency versions |
| `Space mc` | Hide dependency versions |
| `Space mt` | Toggle dependency versions |
| `Space mu` | Update the dependency under the cursor |
| `Space md` | Delete the dependency under the cursor |
| `Space mi` | Install a dependency |
| `Space mp` | Choose a dependency version |

Run `:Lazy` to inspect `package-info.nvim` if annotations do not appear.
Reopen `package.json` after saving it if you created the file in a new buffer.

## Render-markdown

[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
draws headings, lists, checkboxes, tables, code blocks, callouts, and wikilinks
in Markdown buffers. It loads when you open a Markdown file. Rendering applies
in normal and command mode. Insert mode shows the raw Markdown, and the cursor
line stays raw in every mode so you can edit it.

[lua/community.lua](lua/community.lua) imports the AstroCommunity spec
`astrocommunity.markdown-and-latex.render-markdown-nvim`, which installs the
`html`, `markdown`, and `markdown_inline` parsers.
[lua/plugins/render-markdown.lua](lua/plugins/render-markdown.lua) adds:

- The `yaml` parser, for rendering frontmatter.
- The plugin's in-process language server, which completes through blink.cmp.
  On the first line of a block quote it offers callouts such as `[!NOTE]`,
  and after a list marker it offers checkboxes.
- Word wrapping with `linebreak` in Markdown buffers. Other filetypes keep the
  global `wrap = false`.

Icons need a Nerd Font. LaTeX blocks are not rendered, because that needs the
`latex` parser and an external converter such as `utftex` or `latex2text`.

| Command | Action |
| --- | --- |
| `:RenderMarkdown toggle` | Turn rendering on or off in all buffers |
| `:RenderMarkdown buf_toggle` | Turn rendering on or off in the current buffer |
| `:RenderMarkdown preview` | Show a rendered copy of the buffer in a side window |

Run `:checkhealth render-markdown` if a buffer does not render.

## Sidekick

Sidekick requires Neovim 0.11.2 or newer. Install and authenticate at least one
supported CLI, such as OpenCode, Claude, or Codex, before opening it through
Sidekick. The CLI executable must be on Neovim's `PATH`.

If Sidekick is replacing an existing OpenCode plugin integration, remove the
`astrocommunity.ai.opencode-nvim` import, since both use `Space a` mappings.

### Use Sidekick while editing

Start Neovim in your project's root directory, then open a source file.
Save your edits before asking the assistant to read files or review changes.

1. Press `Space as` and choose an installed assistant. Its terminal opens on the right.
2. Return to the code with `Ctrl+h`, or press `Ctrl+z` to return to the previous window.
3. Select code with `v` or `V`, then press `Space av` to add it to the assistant's input.
4. Add your request in the assistant terminal, then press Enter to submit it.
5. Review changed buffers and use `Space gt` to inspect Git status before committing.

Context and prompt shortcuts fill the CLI input without submitting it. File
context sends a path for the assistant to read. Visual selection context
includes the selected text, including unsaved edits.

| Key | Mode | Action |
| --- | --- | --- |
| `Space aa` | Normal | Toggle the assistant terminal |
| `Space as` | Normal | Choose an installed assistant or session |
| `Space ao` | Normal | Open OpenCode directly |
| `Space ac` | Normal | Open Claude directly |
| `Space aC` | Normal | Open Codex directly |
| `Space at` | Normal, visual | Add the cursor or selection location |
| `Space af` | Normal | Add the current file path |
| `Space av` | Visual | Add selected text |
| `Space ap` | Normal, visual | Choose a prompt, such as explain, review, or tests |
| `Space ax` | Normal | Add a prompt with the current file's diagnostics |
| `Space ad` | Normal | Detach the assistant session |

In a Snacks file or search picker, press `Alt+a` to send the selected results
to Sidekick. If nothing is selected, Sidekick uses the highlighted result.

Inside the assistant terminal, `Ctrl+p` opens the prompt menu. Press `Ctrl+q`
to enter terminal normal mode, then `q` to hide the terminal. Use `Space aa`
from a code window to show it again.

When tmux is installed, Sidekick uses it to keep CLI sessions alive after Neovim
exits. Without tmux, it uses an ordinary Neovim terminal, whose process ends
when Neovim exits. File watching and `autoread` refresh buffers when the
assistant changes files on disk. Unsaved buffers still need manual reconciliation.

### Check the integration

Run `:Lazy` and confirm that `sidekick.nvim` is installed. Then run
`:Sidekick cli select` or press `Space as` to check tool detection.

Run `:checkhealth sidekick` to inspect CLI and tmux checks. Sidekick currently
reports a missing Copilot LSP server even when next edit suggestions are disabled.
That Copilot check does not prevent the CLI integration from working.
Warnings about uninstalled assistants refer to optional tools.

If an installed assistant is missing from the picker, run
`:echo executable('opencode')`, substituting its command name. A result of `0`
means Neovim cannot find the executable. Authentication happens in each CLI.

Copilot next edit suggestions are disabled in `lua/plugins/sidekick.lua`, and
Tab keeps AstroNvim's existing completion and snippet behavior. To add next edit
suggestions later, configure and authenticate the Copilot LSP, enable NES, and
follow [Sidekick's Blink integration](https://github.com/folke/sidekick.nvim#installation).

## Maintenance

Use these commands to inspect and update the installation:

| Command | Action |
| --- | --- |
| `:Lazy` | Inspect plugins and installation errors |
| `:Lazy check` | Check for plugin updates |
| `:Lazy update` | Update plugins |
| `:Mason` | Inspect installed language tools |
| `:MasonToolsInstall` | Install missing tools requested by the config |
| `:AstroUpdate` | Update plugins and Mason tools |
| `:TSInstall lua` | Install a language parser manually |
| `:checkhealth` | Check editor and plugin dependencies |

After an AstroNvim update, restart Neovim and run `:Lazy update` again if prompted
so its updated plugin snapshot takes effect.

## Configuration

`lua/community.lua` imports language packs and the render-markdown spec before
the specs in `lua/plugins/`.
Sidekick's options, shortcuts, and Snacks integration live in
`lua/plugins/sidekick.lua`. Package-info's shortcuts and which-key group live in
`lua/plugins/package-info.lua`, with setup inherited from the TypeScript pack.
Render-markdown's options and the Markdown wrap autocommand live in
`lua/plugins/render-markdown.lua`.

Files beginning with `if true then return {} end` are inactive template examples.
Remove that guard only when you intend to enable the file. The language packs
already configure their own servers and tools.

`lazy-lock.json` is currently ignored. Track it if you want the same resolved
plugin versions across machines, especially for plugins outside AstroNvim's
version snapshot, such as Sidekick.
