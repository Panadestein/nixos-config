# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "895f48c5856456ea73cf4237bdcb334ab2640f31";
      sha256 = "0yxgs3svc0dfiyl12cbi071lk1hd09g9r2arlyf6z9fvxm38ds05";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
