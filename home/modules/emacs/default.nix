# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "d8477f064c5b3e03bd71e7fd0c3e5b204826a46a";
      sha256 = "107lnnfqa0324rx960l3pfrgwqh9y1lg3msra0zj0wyjcidbrkqx";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
