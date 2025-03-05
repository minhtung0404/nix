-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- see: https://github.com/christoomey/vim-tmux-navigator/blob/master/plugin/tmux_navigator.vim
--
---- overwrite lazyvim mappings with vim-tmux-navigator mappings

-- vim.keymap.del({ "n", "i", "v" }, "<A-j>")
-- vim.keymap.del({ "n", "i", "v" }, "<A-k>")

if not vim.g.vscode then
	if os.getenv("SSH_TTY") == nil then
		vim.cmd([[
    nnoremap <silent> <c-h> :KittyNavigateLeft<cr>
    nnoremap <silent> <c-l> :KittyNavigateRight<cr>
    nnoremap <silent> <c-j> :KittyNavigateDown<cr>
    nnoremap <silent> <c-k> :KittyNavigateUp<cr>
  ]])
	end
else
	vim.cmd([[
    nnoremap <leader>bd <Cmd>call VSCodeNotify('workbench.action.closeWindow')<cr>
    nnoremap <leader>e <Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<cr>
    nnoremap <leader>t <Cmd>call VSCodeNotify('workbench.action.togglePanel')<cr>
    map <silent> <leader>r :<c-u>luafile $MYVIMRC<cr>
  ]])
end
