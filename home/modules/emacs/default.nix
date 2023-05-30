# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "3f15b5eb4927fea8ad7bb41576cf4ba2a80e9bee";
      sha256 = "0z8l9dwaf4b3s1ybilasiw3vkd12jqrhyc949dr6m14grrwcmifr";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
