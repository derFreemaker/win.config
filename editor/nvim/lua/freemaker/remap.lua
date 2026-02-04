vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("v", "j", ">+1<cr>gv=gv")
vim.keymap.set("v", "k", "<-2<cr>gv=gv")

vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><Cw>\>/<C-r><C-w>/gI<Left><Left><Left>]])

