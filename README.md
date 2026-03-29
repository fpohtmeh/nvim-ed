# Ed's Neovim Configuration

Personal Neovim setup focused on AI-assisted development, git workflows, and productivity.

## Features

- **Claude Integration**: AI pair programming via Claude Code terminal
- **Smart LSP**: Auto-configured language servers with Mason
- **File Management**: Oil.nvim explorer + Zoxide integration
- **Rich UI**: Snacks.nvim framework with custom tabline/statusline
- **Git Workflow**: Fugitive, GitSigns, Lazygit integration
- **Performance**: Lazy loading, optimized startup

## Structure

```
lua/
├── config/          # Core settings, keymaps, autocmds, lazy bootstrap
├── core/            # Shared utilities (fs, lsp, terminal, icons, claude)
└── plugins/         # Plugin specs (auto-imported by lazy.nvim)
    ├── colorscheme/ # Theme configuration
    ├── git/         # Git integration
    ├── lualine/     # Statusline/winbar/tabline
    ├── snacks/      # UI framework
    └── ...
after/ftplugin/      # Filetype overrides
snippets/            # JSON snippets
queries/             # Treesitter queries
docs/                # Cheatsheet, keymaps, plugin list
```

## Requirements

- Neovim >= 0.10
- Git, Node.js, Python
- Ripgrep (search)
- Nerd Font (icons)
