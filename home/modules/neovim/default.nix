# Neovim configuration
{ pkgs, ... }:
let
  theme = import ../../theme.nix;
  nvimTheme = ''
    set background=dark
    highlight clear
    if exists("syntax_on") | syntax reset | endif
    let g:colors_name = "oehme"

    highlight Normal       guifg=${theme.foreground} guibg=${theme.background}
    highlight Cursor       guifg=${theme.background} guibg=${theme.accent}
    highlight CursorLine   guibg=${theme.lighterBackground}
    highlight Visual       guibg=${theme.selection}
    highlight LineNr       guifg=${theme.muted} guibg=${theme.background}
    highlight CursorLineNr guifg=${theme.yellow} guibg=${theme.lighterBackground} gui=bold
    highlight Comment      guifg=${theme.darkForeground} gui=italic
    highlight Constant     guifg=${theme.orange}
    highlight String       guifg=${theme.green}
    highlight Identifier   guifg=${theme.cyan}
    highlight Function     guifg=${theme.blue}
    highlight Statement    guifg=${theme.magenta} gui=bold
    highlight PreProc      guifg=${theme.yellow}
    highlight Type         guifg=${theme.accent}
    highlight Special      guifg=${theme.brightCyan}
    highlight Error        guifg=${theme.brightForeground} guibg=${theme.red}
    highlight Todo         guifg=${theme.darkerBackground} guibg=${theme.yellow} gui=bold
    highlight Search       guifg=${theme.darkerBackground} guibg=${theme.yellow}
    highlight IncSearch    guifg=${theme.darkerBackground} guibg=${theme.orange}
    highlight StatusLine   guifg=${theme.brightForeground} guibg=${theme.selection}
    highlight StatusLineNC guifg=${theme.muted} guibg=${theme.darkBackground}
    highlight Pmenu        guifg=${theme.foreground} guibg=${theme.lighterBackground}
    highlight PmenuSel     guifg=${theme.brightForeground} guibg=${theme.selection}
    highlight VertSplit    guifg=${theme.selection} guibg=${theme.background}
    highlight DiffAdd      guifg=${theme.green} guibg=${theme.darkBackground}
    highlight DiffChange   guifg=${theme.yellow} guibg=${theme.darkBackground}
    highlight DiffDelete   guifg=${theme.red} guibg=${theme.darkBackground}
  '';
in
{
  home.packages = with pkgs; [
    neovim
    pyright
  ];

  xdg.configFile."nvim/init.lua".text = ''
    vim.opt.runtimepath:prepend("${pkgs.vimPlugins.vim-plug}")
  ''
  + builtins.readFile ./init.lua;
  xdg.configFile."nvim/colors/oehme.vim".text = nvimTheme;
}
