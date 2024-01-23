# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "b00cae2da19a792c6f6d74e506a338905065ef79";
      sha256 = "0ysfw0k8a7b10bs8icg55zygz49h0iwm0vci0gvfajyg0v14f1cq";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
