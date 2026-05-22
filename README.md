# yank-reference.nvim

A tiny Neovim plugin that yanks a reference to the current file and line(s) into
the system clipboard, in the form `@path/to/file#L` or `@path/to/file#start-end`.

Useful for pasting precise code references into AI chat tools (Claude Code,
Cursor, Aider, Copilot Chat, ...), GitHub comments, Slack, documentation, or PR
descriptions.

## Why

When you ask an AI assistant about a specific piece of code, the model performs
better if you point it at exactly where the code lives. Manually typing
`src/foo/bar.ts` lines 42-58 is friction. With this plugin you place the cursor
(or make a visual selection) and run one command — the formatted reference is on
your clipboard, ready to paste.

## Features

- Single command, no configuration required
- Works in normal mode (current line) and all visual modes — character `v`,
  line `V`, and block `<C-V>`
- Outputs `@<relative-path>#<line>` or `@<relative-path>#<start>-<end>`
- Writes to the `*` register (system clipboard)
- Lazy-loaded by command — no startup cost until first invocation
- Zero dependencies, single file

## Requirements

- Neovim >= 0.7
- A working clipboard provider — verify with `:checkhealth provider.clipboard`

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "vanppo/yank-reference.nvim",
  cmd = "YankReference",
  keys = {
    { "<leader>yr", "<cmd>YankReference<cr>", mode = { "n", "x" }, desc = "Yank file reference" },
  },
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
  "vanppo/yank-reference.nvim",
  cmd = "YankReference",
})
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'vanppo/yank-reference.nvim'
```

## Usage

Run the command from any buffer that has an associated file:

```vim
:YankReference
```

### Output format

| Context                                | Clipboard output       |
| -------------------------------------- | ---------------------- |
| Normal mode, cursor on line 42         | `@src/foo.lua#42`      |
| Visual selection from line 10 to 25    | `@src/foo.lua#10-25`   |
| Visual-line or visual-block selection  | same range output      |

The leading `@` lets most AI assistants automatically recognise the string as a
file reference and look it up.

### Suggested keymap

```lua
vim.keymap.set({ "n", "x" }, "<leader>yr", "<cmd>YankReference<cr>", { desc = "Yank file reference" })
```

## Configuration

The plugin works out of the box and exposes no options yet. `setup()` is kept as
a stub so it remains compatible with plugin managers that always call it:

```lua
require("yank-reference").setup({})
```

## How it works

- Path is resolved with `vim.fn.expand("%:.")` — relative to the current working
  directory.
- Line numbers:
  - Normal mode — `vim.api.nvim_win_get_cursor(0)`
  - Visual modes — `vim.fn.line("v")` and `vim.fn.line(".")`, normalised with
    `math.min` / `math.max` so a backwards selection still produces `start-end`.
- The result is written to register `*` via `vim.fn.setreg("*", ...)`.

> **Note on the clipboard register**
>
> On macOS and Windows, register `*` is the system clipboard. On Linux with
> X11/Wayland, `*` is the PRIMARY (mouse middle-click) selection — if you want
> the regular clipboard you should either configure
> `vim.opt.clipboard = "unnamedplus"` so the providers bridge the two, or open
> an issue and the register can be made configurable.

## License

MIT
