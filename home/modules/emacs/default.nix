# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "592e3cf494391d9396fa8e7718f84e218549ad5c";
      sha256 = "07kbkl2l0nvslh8iffc8racxxpscf68rwnd15c1mwl99m7xh17gy";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
