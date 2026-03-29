# Key Bindings Reference

## Leaders
- **Leader**: `<Space>`
- **Local Leader**: `\`

## Essential Keys

### File Operations
| Key | Action |
|-----|--------|
| `<C-s>` | Save file |
| `<leader>fn` | New file |
| `<leader>fr` | Rename file |
| `<leader>fx` | Delete file |
| `<leader>e` | File explorer |
| `<leader>E` | Explorer (cwd) |

### Navigation
| Key | Action |
|-----|--------|
| `;b` / `,b` | Next/Previous buffer |
| `<S-h>` / `<S-l>` | Start/End of line |
| `<C-1>` to `<C-5>` | Go to window 1-5 |

### Buffers & Windows
| Key | Action |
|-----|--------|
| `<leader>x` | Delete buffer |
| `<leader>X` | Delete other buffers |
| `<leader>w` | Close window |
| `<leader>W` | Close other windows |

### Terminal
| Key | Action |
|-----|--------|
| `<C-/>` | Toggle terminal |
| `<leader>tt` | Terminal (fullscreen) |
| `<leader>tv` | Terminal (vsplit) |
| `<S-Esc>` | Normal mode (in terminal) |

### Git
| Key | Action |
|-----|--------|
| `<leader>G` | Lazygit |
| `<leader>d` | Zoxide directory picker |

### Claude
| Key | Action |
|-----|--------|
| `<leader>ar` | Toggle Claude (resume) |
| `<leader>an` | Toggle Claude (new) |
| `<leader>at` | Send text to Claude |
| `<leader>as` | Submit text to Claude |
| `<leader>aq` | Send quickfix list |
| `<leader>ac` | Commit |
| `<leader>ax` | Clear |

## LSP Keys (when attached)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `gR` | Rename symbol |
| `gA` | Code actions |
| `;d` / `,d` | Next/Previous diagnostic |
| `;e` / `,e` | Next/Previous error |

## Text Editing

| Key | Action |
|-----|--------|
| `<A-j>` / `<A-k>` | Move line up/down |
| `<C-a>` / `<C-x>` | Increment/Decrement |

## Patterns
- `;` = Next (forward)
- `,` = Previous (backward)
- `<leader>f*` = File operations
- `<leader>a*` = AI operations
