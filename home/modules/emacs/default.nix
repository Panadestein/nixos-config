# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "4c524425e4c97a6e764493e0440214465c44d06e";
      sha256 = "0gvmg8zrqsapd0nyqn0vxhd156cdc5akj441860a6g34g503xnhq";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
