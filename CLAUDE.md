# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim config in Lua, managed by lazy.nvim. Act as a Neovim expert — help with plugin configuration, keymapping, and Lua API usage following this codebase's patterns.

## Architecture

`init.lua` → `lua/config/init.lua` loads: options, globals, lazy.nvim, autocmds, keymaps.

- `lua/config/` — Neovim settings, keymaps, autocmds, lazy bootstrap
- `lua/core/` — Shared utilities and constants. `core.init` exports `border`, `keys` (next=`;`, prev=`,`), `indentation`, `trailspace`
- `lua/plugins/` — Plugin specs (auto-imported via `{ import = "plugins" }`). Larger plugins use folders with `init.lua` + sibling files
- `after/ftplugin/`, `snippets/`, `queries/` — Filetype overrides, JSON snippets, Treesitter queries

Globals: `_G.Ed` (config settings), `_G.Snacks` (snacks.nvim).

Auto-format on save via conform.nvim → `core/format.lua`. Lua uses stylua (`-- stylua: ignore` to skip).

LSP keymaps in `core/lsp.lua`, attached via `LspAttach` autocmd.

Installed plugins at `~/.local/share/nvim-ed/lazy/` — read source directly when needed. Dev plugins at `~/Projects/Nvim`.

## Conventions

- Local helpers/variables in `local H = {}`, not bare top-level locals
- Lazy-load plugins (`event`, `cmd`, `keys`, `ft`). Use custom `LazyFile` event instead of `BufReadPost`/`BufNewFile`/`BufWritePre`
- Leader=`<Space>`, local leader=`\`
- Indentation: 4 spaces default, 2 for markdown/lua
- Border: `"single"`
