# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "d1441dca0928b92f84c0184aa4a54375795732ff";
      sha256 = "1vif2msjcv8djr9lhlf3bnz40mb86cfsjff3gar62gi6dmkgxhqi";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
