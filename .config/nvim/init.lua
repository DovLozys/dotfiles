vim.opt.listchars = { tab = [[▸\ ]], eol = '¬', space = '.' }
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy_plugins = {
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"}
}

local lazy_options = {
	ui = {
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
}

require("lazy").setup(lazy_plugins, lazy_options)

local tele_builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', tele_builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', tele_builtin.live_grep, {})

local ts_config = require("nvim-treesitter.configs")
ts_config.setup({
	ensure_installed = {"css", "go", "python", "javascript", "lua"},
	highlight = { enable = true },
        indent = { enable = true },
})

