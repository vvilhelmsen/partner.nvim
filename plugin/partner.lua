local ok, partner = pcall(require, 'partner')
if not ok then
	vim.notify("partner.nvim: module not found on runtimepath", vim.log.levels.ERROR)
	return
end

partner.setup({
	storage_path = nil,
})

-- Default keybinds
vim.keymap.set('n', '<leader>pa', function() partner.add_or_arm() end,
	{ desc = 'partner: add/arm pairing', silent = true })
vim.keymap.set('n', '<leader>pp', function() partner.toggle() end,
	{ desc = 'partner: toggle partner', silent = true })
