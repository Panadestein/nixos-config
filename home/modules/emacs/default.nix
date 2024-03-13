# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "a145e549cee53172e338312658930d8e5ee96016";
      sha256 = "1icq37x79v1q6ychk5364hnqi8vc1j0d19qqj3wgzxpwc0la6p2d";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
