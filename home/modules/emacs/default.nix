# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "05d89658b47c896a0942adbe9f941bd1bc8289e6";
      sha256 = "14g3nnd4x882f7grfawx3z6wc7q6l4wr5hbk290xf9p24snc8vnn";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
