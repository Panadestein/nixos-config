-- A small, modern fallback editor configuration.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.wrap = true
opt.spell = true
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.clipboard = "unnamedplus"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to install lazy.nvim:\n", "ErrorMsg" },
      { output, "WarningMsg" },
    }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "bash", "json", "lua", "markdown", "nix", "python", "yaml" },
      highlight = { enable = true },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      vim.lsp.config("pyright", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
      vim.lsp.enable("pyright")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }, { { name = "buffer" } }),
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Search text" },
      { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    keys = { { "<leader>e", "<cmd>Oil<cr>", desc = "File explorer" } },
  },
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "auto" } } },
})

pcall(vim.cmd.colorscheme, "oehme")

local python = vim.api.nvim_create_augroup("python_settings", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = python,
  pattern = { "*.py", "*.pyw" },
  callback = function()
    vim.opt_local.textwidth = 79
    vim.opt_local.fileformat = "unix"
  end,
})

vim.keymap.set("n", "<F9>", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("Write the buffer before running it", vim.log.levels.WARN)
    return
  end
  vim.cmd("write")
  vim.cmd("split | terminal python3 " .. vim.fn.shellescape(file))
end, { desc = "Run current Python file" })
