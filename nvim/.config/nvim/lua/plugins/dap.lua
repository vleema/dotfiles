return {
  "rcarriga/nvim-dap-ui",
  opts = {
    layouts = {
      {
        elements = {
          -- Customize which elements to show
          { id = "scopes", size = 0.25 },
          { id = "breakpoints", size = 0.25 },
          { id = "stacks", size = 0.25 },
          { id = "watches", size = 0.25 },
          -- Remove "repl" from here to hide it
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          { id = "console", size = 1.0 },
          -- You can also remove "repl" from this layout if it's here
        },
        size = 10,
        position = "bottom",
      },
    },
  },
}
