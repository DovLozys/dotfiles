require'nvim-treesitter.configs'.setup {
  ensure_installed = { 'c', 'lua', 'rust', 'go', 'javascript', 'typescript' },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}
