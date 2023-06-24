# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "3cccd1a0e514e63a3d2443d79afc83ac3283a028";
      sha256 = "1888qkmycznrz1w78c43ghln6y0pjnz9izcx8qjwq38ar7s08qya";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
