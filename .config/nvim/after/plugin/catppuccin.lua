require('catppuccin').setup({
  highlight_overrides = {
    all = function(colors)
      return {
        EndOfBuffer = { fg = colors.surface1 },
      }
    end,
  }
})

