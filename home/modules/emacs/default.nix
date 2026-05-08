# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "bd2682add2a55e64f23e3e1b9ed103bb0c2b6350";
      sha256 = "05bdi3f2akm1160lkbgj6nmqv20ak8c00f9f8lwmzd5l9ri448y9";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
