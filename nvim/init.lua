vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 8
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.list = true
vim.opt.listchars = {
	tab = " -→",
	trail = "·",
	space = "·",
	extends = "⇢",
	precedes = "⇠",
	eol = "¬",
	nbsp = "␣",
}

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("HighlightYank", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 250 })
	end,
})
