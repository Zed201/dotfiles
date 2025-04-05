return {
  {

    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        shade_terminals = false,
        autochdir = true,
      })
    end,
    keys = {
      {
        "<leader>th",
        "<cmd>ToggleTerm size=15 direction=horizontal dir=git_dir<CR>",

        desc = "Open a horizontal H",
      },
      {
        "<leader>tv",
        "<cmd>ToggleTerm size=60 direction=vertical dir=git_dir<CR>",

        desc = "Open a horizontal v",
      },
      {
        "<leader>tf",
        "<cmd>ToggleTerm size=60 direction=float dir=git_dir<CR>",

        desc = "Open a horizontal v",
      },
    },
  },
}
