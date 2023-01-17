# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "0a903656f8cc9b8e4de2a7bd4e6401bd499f8189";
      sha256 = "03hxys764dhn0va83yfdbxamgpvv9rm2jwy0laxsxv41k9r9zq6l"; 
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
