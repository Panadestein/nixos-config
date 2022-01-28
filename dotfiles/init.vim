"----------------------------------
"      _   ___     _____ __  __ 
"     | \ | \ \   / /_ _|  \/  |
"     |  \| |\ \ / / | || |\/| |
"     | |\  | \ V /  | || |  | |
"     |_| \_|  \_/  |___|_|  |_|
"
" A simple Neovi(m|de) configuration
"   (dankly optimized for Neovide)
"-----------------------------------

"----------------------------------------
" General settings
"----------------------------------------

set nocompatible            " Breaks Vim compatibility
set encoding=utf-8          " Set encoding
set showmatch               " Matching parenthesis
set ignorecase              " Case insensitive
set mouse=v                 " Middle-click paste with
set hlsearch                " Highlight search results
set incsearch               " Enable incremental search
set tabstop=4               " Tab width
set softtabstop=4           " Multiple spaces as tabstops 
set expandtab               " Converts tabs to white space
set shiftwidth=4            " Width for autoindents
set autoindent              " Indent a new line as previous
set number                  " Enable line numbers
set noshowmode              " Prevent non-normal modes showing in Powerline
set relativenumber          " Relative line numbers
set wrap                    " Wrap text
set wildmode=longest,list   " Bash-like tab completions
filetype plugin indent on   " Auto-indenting depending on file type
syntax on                   " Enable syntax highlighting
set mouse=a                 " Enable mouse click
set clipboard=unnamedplus   " Use system clipboard
set ttyfast                 " Speed up scrolling in Vim
set spell                   " Enable spell checking 
set backupdir=~/.config/nvim/cache " Directory to store backup files
filetype plugin on          " Load plugins for specific filetype
" Remember cursor position
au BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
au BufWinEnter ?* silent! loadview

"----------------------------------------
" Neovide specific
"----------------------------------------

let g:neovide_refresh_rate=140
let g:neovide_transparency=0.1
let neovide_remember_window_size = v:true
let g:neovide_input_use_logo=v:true
let g:neovide_cursor_animation_length=0.13

"----------------------------------------
" Plugin's settings (requires Vimplug)
"----------------------------------------

call plug#begin("~/.config/nvim/plugged")
 Plug 'ryanoasis/vim-devicons'
 Plug 'SirVer/ultisnips'
 Plug 'honza/vim-snippets'
 Plug 'scrooloose/nerdtree'
 Plug 'neovim/nvim-lspconfig'
 Plug 'glepnir/lspsaga.nvim'
 Plug 'wfxr/minimap.vim'
 Plug 'folke/lsp-colors.nvim'
 Plug 'hoob3rt/lualine.nvim'
 Plug 'vim-scripts/indentpython.vim'
 Plug 'nvie/vim-flake8'
 Plug 'lisposter/vim-blackboard'
 Plug 'lervag/vimtex'
 Plug 'rudrab/vimf90'
 Plug 'nvim-lua/completion-nvim'
 Plug 'zchee/deoplete-jedi'
 Plug 'davidhalter/jedi-vim'
 Plug 'neomake/neomake'
 Plug 'akinsho/toggleterm.nvim'
call plug#end()

"----------------------------------------
" Font configuration
"----------------------------------------

set guifont=DejaVu\ Sans\ Mono:h26

"----------------------------------------
" Status line
" (Antidank config --> Migration to init.lua unavoidable)
"----------------------------------------

lua << EOF
require'lualine'.setup { options = { icons_enabled = true, theme = 'ayu_mirage' } }
EOF

"----------------------------------------
" Color schemes
"----------------------------------------

if (has("termguicolors"))
    set termguicolors
endif

syntax enable
colorscheme blackboard
set background=dark
set splitright
set splitbelow

"----------------------------------------
" Terminal support
"----------------------------------------

lua require("toggleterm").setup{}
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>

"----------------------------------------
" LSP and autocompletion settings
"----------------------------------------

lua << EOF
require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}
EOF

" Snippets and pop-up
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_enable_auto_popup = 1

" Autocomplete in every buffer
autocmd BufEnter * lua require'completion'.on_attach()

" Use <Tab> and <S-Tab> to navigate through pop-up menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" disable autocompletion, because we use deoplete for completion
let g:jedi#completions_enabled = 0

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"

"----------------------------------------
" Neomake
"----------------------------------------

nnoremap <C-c>s :Neomake<cr>
nnoremap <C-c>x :NeomakeClean<cr>

function! LocationNext()
  try                                                                                     
    lnext                                                                                 
  catch                                                                                   
    try | lfirst | catch | endtry                                                         
  endtry                                                                                  
endfunction                                                                               

nnoremap <leader>e :call LocationNext()<cr>

"----------------------------------------
" NerdTREE config
"----------------------------------------

noremap <F2> :NERDTreeToggle<CR>

"----------------------------------------
" Python stuff (PEP8 compliant)
"----------------------------------------

let python_highlight_all=1
let g:neomake_python_enabled_makers = ['pylint']
nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>
au BufNewFile, BufRead *.py
    \ set tabstop=4        | 
    \ set softtabstop=4    | 
    \ set shiftwidth=4     |
    \ set textwidth=79     |   
    \ set expandtab        |   
    \ set autoindent       | 
    \ set fileformat=unix
au BufRead, BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

"----------------------------------------
" FORTRAN stuff
"----------------------------------------

let fortran_free_source=1
let fortran_have_tabs=1
let fortran_do_enddo=1
let fortran_linter=1

"----------------------------------------
" TEX stuff
"----------------------------------------

let g:tex_flavor='latex'
let g:vimtex_compiler_latexmk = { 'continuous' : 0 }
let g:vimtex_compiler_latexmk_engines = {  '_' : '-pdf'}

