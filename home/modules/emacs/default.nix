# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "65275f8486e477b2556d024b506da442dbc34b43";
      sha256 = "14349g8jzxl3m36chjdhsj18z67c8z81c12968ja8mxlnn2ndqjv"; 
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
