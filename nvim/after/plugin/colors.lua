function LoadColorScheme(color)
	color = color or "tokyonight-storme"
	vim.cmd.colorscheme(color)

evim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

LoadColorScheme()

