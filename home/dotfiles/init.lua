-- A simple Neovim configuration

----------------------------------------
-- General settings
----------------------------------------

vim.opt.showmatch = true          -- Matching parenthesis
vim.opt.ignorecase = true         -- Case insensitive
vim.opt.mouse = "a"               -- Enable mouse click
vim.opt.hlsearch = true           -- Highlight search results
vim.opt.incsearch = true          -- Enable incremental search
vim.opt.tabstop = 4               -- Tab width
vim.opt.softtabstop = 4           -- Multiple spaces as tabstops
vim.opt.expandtab = true          -- Converts tabs to white space
vim.opt.shiftwidth = 4            -- Width for autoindents
vim.opt.autoindent = true         -- Indent a new line as previous
vim.opt.number = true             -- Enable line numbers
vim.opt.relativenumber = true     -- Relative line numbers
vim.opt.wrap = true               -- Wrap text
vim.opt.showmode = false          -- Prevent non-normal modes showing in Powerline/statusline
vim.opt.wildmode = { "longest", "list" } -- Bash-like tab completions
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.spell = true              -- Enable spell checking
local backup_dir = vim.fn.stdpath("state") .. "/backup"
vim.fn.mkdir(backup_dir, "p")
vim.opt.backupdir = backup_dir .. "//" -- Keep full paths to avoid basename collisions
vim.opt.termguicolors = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.shortmess:append("c")
vim.opt.guifont = "DejaVu Sans Mono:h26"

-- Remember cursor position
local view_group = vim.api.nvim_create_augroup("AutoView", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufLeave", "BufWritePost", "BufHidden", "QuitPre" }, {
    group = view_group,
    pattern = "?*",
    command = "silent! mkview!",
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = view_group,
    pattern = "?*",
    command = "silent! loadview",
})

----------------------------------------
-- Plugin settings (requires vim-plug)
----------------------------------------

local Plug = vim.fn["plug#"]
vim.call("plug#begin", "~/.config/nvim/plugged")
Plug("ryanoasis/vim-devicons")
Plug("SirVer/ultisnips")
Plug("honza/vim-snippets")
Plug("scrooloose/nerdtree")
Plug("neovim/nvim-lspconfig")
Plug("glepnir/lspsaga.nvim")
Plug("wfxr/minimap.vim")
Plug("folke/lsp-colors.nvim")
Plug("hoob3rt/lualine.nvim")
Plug("vim-scripts/indentpython.vim")
Plug("nvie/vim-flake8")
Plug("lervag/vimtex")
Plug("rudrab/vimf90")
Plug("nvim-lua/completion-nvim")
Plug("zchee/deoplete-jedi")
Plug("davidhalter/jedi-vim")
Plug("neomake/neomake")
Plug("akinsho/toggleterm.nvim")
Plug("https://git.sr.ht/~detegr/nvim-bqn")
Plug("mlochbaum/BQN", { rtp = "editors/vim" })
vim.call("plug#end")

----------------------------------------
-- Status line
----------------------------------------

local has_lualine, lualine = pcall(require, "lualine")
if has_lualine then
    lualine.setup({ options = { icons_enabled = true, theme = "auto" } })
end

----------------------------------------
-- Color schemes
----------------------------------------

vim.opt.background = "dark"
pcall(vim.cmd.colorscheme, "oehme")

----------------------------------------
-- Terminal support
----------------------------------------

local has_toggleterm, toggleterm = pcall(require, "toggleterm")
if has_toggleterm then
    toggleterm.setup({})
end
vim.keymap.set("n", "<C-t>", '<Cmd>exe v:count1 . "ToggleTerm"<CR>', { silent = true })
vim.keymap.set("i", "<C-t>", '<Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>', { silent = true })

----------------------------------------
-- LSP and autocompletion settings
----------------------------------------

local has_lspconfig, lspconfig = pcall(require, "lspconfig")
if has_lspconfig then
    local on_attach = function(client, bufnr)
        local has_completion, completion = pcall(require, "completion")
        if has_completion then
            completion.on_attach(client, bufnr)
        end
    end
    if lspconfig.pyright then
        lspconfig.pyright.setup({ on_attach = on_attach })
    end
end

vim.g.completion_enable_snippet = "UltiSnips"
vim.g.completion_enable_auto_popup = 1

local completion_group = vim.api.nvim_create_augroup("CompletionAttach", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    group = completion_group,
    pattern = "*",
    callback = function()
        local has_completion, completion = pcall(require, "completion")
        if has_completion then
            completion.on_attach()
        end
    end,
})

-- <Tab> and <S-Tab> to navigate through pop-up menu
vim.keymap.set("i", "<Tab>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true, remap = false })
vim.keymap.set("i", "<S-Tab>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true, remap = false })

-- Disable autocompletion because deoplete is used
vim.g["jedi#completions_enabled"] = 0
vim.g["jedi#use_splits_not_buffers"] = "right"

----------------------------------------
-- Neomake
----------------------------------------

vim.keymap.set("n", "<C-c>s", "<Cmd>Neomake<CR>", { silent = true })
vim.keymap.set("n", "<C-c>x", "<Cmd>NeomakeClean<CR>", { silent = true })

function LocationNext()
    local ok = pcall(vim.cmd.lnext)
    if not ok then
        pcall(vim.cmd.lfirst)
    end
end
vim.keymap.set("n", "<leader>e", LocationNext, { silent = true })

----------------------------------------
-- NERDTree config
----------------------------------------

vim.keymap.set({ "n", "v" }, "<F2>", "<Cmd>NERDTreeToggle<CR>", { silent = true })

----------------------------------------
-- Python stuff (PEP8 compliant)
----------------------------------------

vim.g.python_highlight_all = 1
vim.g.neomake_python_enabled_makers = { "pylint" }

local python_group = vim.api.nvim_create_augroup("PythonSettings", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = python_group,
    pattern = "*.py",
    callback = function(ev)
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.textwidth = 79
        vim.opt_local.expandtab = true
        vim.opt_local.autoindent = true
        vim.opt_local.fileformat = "unix"

        vim.keymap.set("n", "<F9>", function()
            local file = vim.fn.expand("%")
            vim.cmd("!python " .. vim.fn.shellescape(file, 1))
        end, { buffer = ev.buf, silent = true })
    end,
})

local whitespace_group = vim.api.nvim_create_augroup("BadWhitespace", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = whitespace_group,
    pattern = { "*.py", "*.pyw", "*.c", "*.h" },
    command = "match BadWhitespace /\\s\\+$/",
})

----------------------------------------
-- FORTRAN stuff
----------------------------------------

vim.g.fortran_free_source = 1
vim.g.fortran_have_tabs = 1
vim.g.fortran_do_enddo = 1
vim.g.fortran_linter = 1

----------------------------------------
-- TEX stuff
----------------------------------------

vim.g.tex_flavor = "latex"
vim.g.vimtex_compiler_latexmk = { continuous = 0 }
vim.g.vimtex_compiler_latexmk_engines = { _ = "-pdf" }
