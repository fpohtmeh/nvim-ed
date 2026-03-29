# Key Bindings Reference

## Patterns

- `;` = Next (forward), `,` = Previous (backward)
- `<leader>a*` = AI, `<leader>f*` = File, `<leader>h*` = Git hunks
- `<leader>j*` = Tasks, `<leader>r*` = Replace, `<leader>s*` = Search
- `<leader>y*` = Yank, `<leader>n*` = Notifications

## Leaders

- **Leader**: `<Space>`
- **Local Leader**: `\`

## File Operations

| Key          | Action              |
| ------------ | ------------------- |
| `<C-s>`      | Save file           |
| `<leader>fn` | New file            |
| `<leader>fr` | Rename file         |
| `<leader>fx` | Delete file         |
| `<leader>e`  | File explorer       |
| `<leader>E`  | File explorer (cwd) |

## Navigation

| Key                | Action                       |
| ------------------ | ---------------------------- |
| `<S-h>` / `<S-l>`  | Start/End of line            |
| `<C-1>` to `<C-5>` | Go to window 1-5             |
| `;b` / `,b`        | Next/Previous buffer         |
| `<leader><tab>`    | New tab                      |
| `<leader>1-9`      | Go to tab 1-9                |
| `gq` / `gQ`        | Close tab / Close other tabs |

## Buffers & Windows

| Key             | Action               |
| --------------- | -------------------- |
| `<leader>x`     | Delete buffer        |
| `<leader>X`     | Delete other buffers |
| `<leader><C-x>` | Delete all buffers   |
| `<leader>w`     | Close window         |
| `<leader>W`     | Close other windows  |
| `<leader>Q`     | Quit all             |

## Picker (Snacks)

| Key               | Action                       |
| ----------------- | ---------------------------- |
| `<leader><space>` | Find files                   |
| `<leader>/`       | Grep                         |
| `<leader>b`       | Buffers                      |
| `<leader>sl`      | LSP symbols (buffer)         |
| `<leader>sh`      | Help pages                   |
| `<leader>sw`      | Grep word / visual selection |
| `<leader>sb`      | Grep open buffers            |
| `<leader>sH`      | Highlights                   |
| `<leader>sc`      | HTML colors                  |
| `<leader>sp`      | Projects                     |
| `<leader>sR`      | Recent files                 |
| `<leader>ss`      | All pickers                  |
| `<leader>sr`      | Resume last picker           |

## Search & Replace (Grug-far)

| Key          | Action                            |
| ------------ | --------------------------------- |
| `<leader>rr` | Search and replace                |
| `<leader>rw` | Search and replace (word)         |
| `<leader>rf` | Search and replace (in file)      |
| `<leader>rd` | Search and replace (in directory) |

## Git

| Key          | Action                    |
| ------------ | ------------------------- |
| `<leader>G`  | Lazygit                   |
| `<leader>hs` | Stage hunk                |
| `<leader>hr` | Reset hunk                |
| `<leader>hS` | Stage buffer              |
| `<leader>hh` | Stage line(s)             |
| `<leader>hu` | Undo stage hunk           |
| `<leader>hR` | Reset buffer              |
| `<leader>hU` | Unstage buffer            |
| `<leader>hp` | Preview hunk inline       |
| `<leader>hb` | Blame line                |
| `<leader>hB` | Blame buffer              |
| `<leader>hd` | Diff this                 |
| `<leader>hD` | Diff this (prev commit)   |
| `;h` / `,h`  | Next/Previous hunk        |
| `;H` / `,H`  | Last/First hunk           |
| `ih`         | Select hunk (text object) |

## Terminal

| Key          | Action                    |
| ------------ | ------------------------- |
| `<C-/>`      | Toggle terminal           |
| `<leader>tt` | Terminal (window)         |
| `<leader>tf` | Terminal (fullscreen)     |
| `<leader>tv` | Terminal (vsplit)         |
| `<S-Esc>`    | Normal mode (in terminal) |

## Claude

| Key          | Action                 |
| ------------ | ---------------------- |
| `<leader>ar` | Toggle Claude (resume) |
| `<leader>an` | Toggle Claude (new)    |
| `<leader>at` | Send text              |
| `<leader>as` | Submit text            |
| `<leader>aq` | Send quickfix list     |
| `<leader>ac` | Commit                 |
| `<leader>ax` | Clear                  |

## Tasks (Overseer)

| Key            | Action                    |
| -------------- | ------------------------- |
| `<leader>jj`   | Select task               |
| `<leader>j.`   | Restart last task         |
| `<leader>jl`   | Toggle tasks list         |
| `<leader><CR>` | Toggle last task output   |
| `<leader>jx`   | Stop last task            |
| `<leader>jr`   | Run task                  |
| `<leader>jb`   | Build task                |
| `<leader>jt`   | Test task                 |
| `;j` / `,j`    | Next/Previous task output |

## Harpoon

| Key             | Action             |
| --------------- | ------------------ |
| `<leader>H`     | Harpoon file       |
| `<leader><C-h>` | Harpoon picker     |
| `<leader><A-h>` | Harpoon quick menu |

## LSP (when attached)

| Key         | Action                       |
| ----------- | ---------------------------- |
| `gd`        | Go to definition             |
| `gD`        | Go to declaration            |
| `gr`        | Find references              |
| `gR`        | Rename symbol                |
| `gI`        | Go to implementation         |
| `gY`        | Go to type definition        |
| `gA`        | Code actions                 |
| `gh`        | Switch source/header (C/C++) |
| `;d` / `,d` | Next/Previous diagnostic     |
| `;e` / `,e` | Next/Previous error          |
| `;w` / `,w` | Next/Previous warning        |

## Text Editing

| Key               | Action                      |
| ----------------- | --------------------------- |
| `<A-j>` / `<A-k>` | Move line up/down           |
| `<C-a>` / `<C-x>` | Increment/Decrement         |
| `;p` / `,p`       | Paste on next/previous line |

## Yank to Clipboard

| Key          | Action             |
| ------------ | ------------------ |
| `<leader>yf` | Yank filepath      |
| `<leader>yn` | Yank filename      |
| `<leader>yr` | Yank relative path |
| `<leader>yd` | Yank directory     |
| `<leader>yb` | Yank git branch    |
| `<leader>yB` | Yank remote branch |
| `<leader>yc` | Yank git commit    |
| `<leader>yC` | Yank short commit  |
| `<leader>yo` | Yank git origin    |

## Misc

| Key               | Action                  |
| ----------------- | ----------------------- |
| `<leader>;`       | Toolbox                 |
| `<leader>d`       | Zoxide directory        |
| `<leader>q`       | Toggle quickfix         |
| `<leader>L`       | Lazy                    |
| `<leader>M`       | Mason                   |
| `<leader>nn`      | Noice messages          |
| `<leader>nx`      | Hide notifications      |
| `<A-t>`           | Toggle zen mode         |
| `<C-f>` / `<C-b>` | Scroll forward/backward |
