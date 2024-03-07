# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "29b140bc25345bc86e14d53482f9f6566e8e86cf";
      sha256 = "0waiwnfq1p41h2slb15ry71ljhyk2fviynb8blvvbbnrjlrdwvxb";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
