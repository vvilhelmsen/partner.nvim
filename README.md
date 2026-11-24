# partner.nvim 🤠

**partner.nvim** is a simple plugin that just does one thing: let you pair files and switch between them.

---

## Use Cases

* **Frontend**: toggle between `index.html` ⇆ `index.js`.
* **Styling**: toggle between `style.css` ⇆ `style.scss`.
* **Tests**: toggle between `module.py` ⇆ `test_module.py`.
* **Configs**: toggle between `.env` ⇆ `.env.example`.
* **Docs & code**: toggle between `README.md` ⇆ `README.template`.
* **Any repeating file pair** you constantly switch between.

---

## Workflow

1. Open **file1** and press `<leader>pa` → file is *armed*.
2. Open **file2** and press `<leader>pa` the two files are now *partners*.
3. Toggle back and forth between them with `<leader>pp`.

---

## Notes

* Each file can only have **one partner**, but you can create as many pairs as you like.
* Pairs are remembered across sessions.

---

## Installation ([lazy.nvim](https://github.com/folke/lazy.nvim))

```lua
return {
  "vvilhelmsen/partner.nvim",
  opts = {
    keymaps = {
      add_or_arm = "<leader>pa",
      toggle     = "<leader>pp",
    },
  },
  config = function(_, opts)
    require("partner").setup(opts)
  end,
}
```

## Statusline

Add `require("partner").statusline` to a section in your
[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) config:

```lua
require("lualine").setup({
  sections = {
    lualine_c = { "filename", require("partner").statusline },
  },
})
```

It shows `Partner: filename` and stays hidden when the current buffer has no
partner.

With Neovim's built-in statusline, include the expression in your format:

```lua
vim.opt.statusline = "%f %m %{%v:lua.require'partner'.statusline()%}%=%l:%c"
```
