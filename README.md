# partner.nvim 🤠

**partner.nvim** is a simple plugin that just does one thing: let you *pair* two files and instantly switch between them.

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
