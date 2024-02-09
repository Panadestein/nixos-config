# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "d0ff06311309cd6f21bfe83e2239e8579d889310";
      sha256 = "07nglc6yk8l6ag352d50yaan1hwb873wkb5c53angd1syqsx2gqn";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
