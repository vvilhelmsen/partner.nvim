local ok, partner = pcall(require, 'partner')
if not ok then
	vim.notify("partner.nvim: module not found on runtimepath", vim.log.levels.ERROR)
	return
end

partner.setup({
	storage_path = nil,
})
