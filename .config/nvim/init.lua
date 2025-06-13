-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- Mapeia 'Alt + \' para sair do modo de inserção do terminal (equivalente a <C-\><C-n>)
vim.api.nvim_set_keymap("t", "<A-\\>", "<C-\\><C-n>", { noremap = true, silent = true })
