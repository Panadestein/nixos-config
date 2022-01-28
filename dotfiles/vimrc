" Vundle configuration (plugin management)
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'morhetz/gruvbox'
Plugin 'lervag/vimtex'
Plugin 'fatih/vim-go'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Bundle 'Valloric/YouCompleteMe'

call vundle#end()          
filetype plugin indent on  

" General appearance and config
syntax on
set number
set relativenumber
set encoding=utf-8
set clipboard=unnamed
set wrap

" Theming ensuring spell highlight
augroup my_colours
  autocmd!
  autocmd ColorScheme gruvbox hi SpellBad cterm=reverse
augroup END
colorscheme gruvbox
set background=dark
highlight Normal ctermbg=None

"Powerline
set laststatus=2 
set showtabline=2 
set noshowmode 

"Autocompletion configuration
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"Python stuff (PEP8)
let python_highlight_all=1
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

" Julia stuff
nnoremap <buffer> <F8> :exec '!julia' shellescape(@%, 1)<cr>

" FORTRAN stuff
let fortran_free_source=1
let fortran_have_tabs=1
let fortran_more_precise=1
let fortran_do_enddo=1

" TEX stuff
let g:tex_flavor='latex'

"Remember cursor position
au BufWinLeave ?* mkview
au BufWinEnter ?* silent loadview

" Spell-check set to <leader>s
map <leader>l :setlocal spell! spelllang=en_us<CR>

"NerdTree
map <F2> :NERDTreeToggle<CR>

"Snippets
let g:UltiSnipsExpandTrigger="<leader>c"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
