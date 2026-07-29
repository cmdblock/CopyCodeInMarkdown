# markdown-code-copy

A Neovim plugin to quickly copy code blocks in Markdown files.

## Features

- Copy fenced code block content with a single keypress
- Select fenced code block content in visual mode
- Only works in Markdown files — no interference elsewhere
- Copies pure code content without ``` markers or language tags
- Uses Neovim's `+` register (system clipboard)

## Requirements

- Neovim >= 0.8
- Clipboard support (`:checkhealth clipboard`)

## Installation

### lazy.nvim

```lua
{
  "your-username/markdown-code-copy",
  ft = "markdown",
  keys = {
    { "<leader>cc", "<cmd>MarkdownCodeCopy<cr>", ft = "markdown", desc = "Copy markdown code block" },
    { "<leader>cs", "<cmd>MarkdownCodeSelect<cr>", ft = "markdown", desc = "Select markdown code block" },
  },
  config = function()
    require("markdown_code_copy").setup()
  end,
}
```

### packer.nvim

```lua
use {
  "your-username/markdown-code-copy",
  ft = "markdown",
  config = function()
    require("markdown_code_copy").setup()
  end,
}
```

### vim-plug

```vim
Plug 'your-username/markdown-code-copy', { 'for': 'markdown' }
```

Then in your `init.lua` or `.vimrc`:

```lua
require("markdown_code_copy").setup()
```

## Configuration

Default options:

```lua
require("markdown_code_copy").setup({
  register = "+",  -- Target register (system clipboard)
})
```

## Usage

1. Open a Markdown file
2. Move your cursor inside a fenced code block (between ``` and ```)
3. Press your configured keymap (e.g. `<leader>cc`)
4. The code content is now in your system clipboard

You can also use the commands:

```vim
:MarkdownCodeCopy   " Copy code block to clipboard
:MarkdownCodeSelect " Select code block in visual mode
```

## License

MIT
