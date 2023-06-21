# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "65bbbab941b2a49e85a0d8f93bd697d34df33ca3";
      sha256 = "158irip46yqs589x1b5k7n77ks37i4nwrr973vsrhgsx51pyq64j";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
