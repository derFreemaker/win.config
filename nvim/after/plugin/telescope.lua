local builtin = require('telescope.builtin')

-- files
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

-- file content
vim.keymap.set('n', '<leader>ff', builtin.live_grep, {})

