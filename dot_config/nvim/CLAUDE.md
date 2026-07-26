# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

LazyVim v8 based Neovim config. `init.lua` bootstraps lazy.nvim, which loads LazyVim core plus custom plugins from `lua/plugins/`.

## Structure

| Directory/File | Purpose |
|---|---|
| `lua/config/options.lua` | All `vim.opt` settings, LazyVim globals |
| `lua/config/keymaps.lua` | *(absent)* — LazyVim defaults are used as-is. Add this file only for real deltas; to drop an upstream map use `vim.keymap.del`, since re-declaring or commenting out upstream lines has no effect |
| `lua/config/autocmds.lua` | Custom autocommands |
| `lua/config/lazy.lua` | lazy.nvim bootstrap + plugin loader setup |
| `lua/plugins/*.lua` | Plugin specs — each file returns a spec table for lazy.nvim |
|
| `snippet/` | Custom snippets |
| `lazy-lock.json` | Pinned plugin versions (auto-generated) |

## Key Design Patterns

- **LazyVim overlay pattern**: Files in `lua/plugins/` return a spec table that merges into LazyVim's defaults via `opts` function parameter (e.g., `opts = function(_, opts) ... end`)
- **Empty specs** like `lua/plugins/lsp.lua` (`return {}`) indicate the LazyVim builtin is used as-is — the file exists only to satisfy LazyVim's picker integration
- Plugin config lives in `opts` function, not `config` — this is the standard LazyVim pattern that allows deep merging with LazyVim internal defaults
- `vim.g` globals (set in `options.lua`) control LazyVim behavior: picker engine, completion engine, Python LSP choice, etc.

## Formatting

stylua with 2-space indent, 120 char column width. Run: `stylua .`

## LazyVim Extras

Enabled via `lazyvim.json`: dap.core, lang.clangd, lang.cmake, lang.json, lang.markdown, lang.python, lang.toml, test.core
