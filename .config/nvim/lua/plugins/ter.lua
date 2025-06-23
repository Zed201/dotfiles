return {
  -- ToggleTerm: Terminal embutido com suporte a múltiplas janelas
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
        desc = "Abrir terminal horizontal (git dir)",
        mode = "n",
      },
      {
        "<leader>tv",
        "<cmd>ToggleTerm size=80 direction=vertical dir=git_dir<CR>",
        desc = "Abrir terminal vertical (git dir)",
        mode = "n",
      },
    },
  },

  -- Floaterm: Terminal flutuante simples(WIP)
  -- a -> new terminal
  -- e -> edit name
  -- C-h -> switch sidebar
  -- C-j -> switch prev
  -- C-k -> switch next
  {
    "nvzone/floaterm",
    dependencies = "nvzone/volt",
    opts = {
      border = false,
      size_h = 60,
      size_w = 70,

      -- Default sets of terminals you'd like to open
      terminals = {
        { name = "Terminal" },
      },
    },
    cmd = "FloatermToggle",
    keys = {
      {
        "<leader>tf",
        "<cmd>FloatermToggle<CR>",
        desc = "Toggle Floaterm (modo normal)",
        mode = "n",
      },
      {
        "<C-t>",
        "<C-\\><C-n><cmd>FloatermToggle<CR>",
        desc = "Toggle Floaterm (modo terminal)",
        mode = "t",
      },
      {
        "<C-t>",
        "<cmd>FloatermToggle<CR>",
        desc = "Toggle Floaterm (modo normal)",
        mode = "n",
      },
    },
  },
}
