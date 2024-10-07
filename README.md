# same-folder-file-cycle

This is a Neovim plugin for quick cycling between related files within the same folder, such as code, templates, stylesheets, and test files. It's ideal for smaller projects with organized file structures.

The default configuration is set for Angular projects, but it can be easily customized for other frameworks and project types.

## Installation

Using `LazyVim`, create a new file in `~/.config/nvim/lua/plugins/same-folder-file-cycle.lua` and add the following:

```lua
return {
  {
    'ruhendrawan/same-folder-file-cycle',
  }
}
```

Then, add keymaps in `~/.config/nvim/lua/config/keymaps.lua`:

```lua
local function opts_desc(desc)
  return { desc = desc, noremap = true, silent = true }
end

local sffc = require("same-folder-file-cycle")
vim.keymap.set("n", "<leader>au", sffc.switch_to_ts, opts_desc("Switch to TypeScript"))
vim.keymap.set("n", "<leader>ai", sffc.switch_to_html, opts_desc("Switch to HTML"))
vim.keymap.set("n", "<leader>ao", sffc.switch_to_css, opts_desc("Switch to CSS"))
vim.keymap.set("n", "<leader>ap", sffc.switch_to_spec, opts_desc("Switch to Spec"))
```

## Other Frameworks

### Laravel PHP with File Based Routing

Example keymaps

```lua
local sffc = require("same-folder-file-cycle")
sfcc.extensions = {
  primary = "php",  -- Controller file
  secondary = "blade.php",  -- Blade template for the view
  allowed = { "blade.php", "php", "css" }, -- Two level extension first (blade.php)
}
vim.keymap.set("n", "<leader>au", sffc.switch_to({ext="php"}), opts_desc("Switch to Code"))
vim.keymap.set("n", "<leader>ai", sffc.switch_to({ext="blade"}), opts_desc("Switch to HTML"))
vim.keymap.set("n", "<leader>ao", sffc.switch_to({ext="css"}), opts_desc("Switch to CSS"))
`
```
