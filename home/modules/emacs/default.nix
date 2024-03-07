# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "f2aa018816637ae3f7200c725b214ddd07697d2c";
      sha256 = "1zkwkcfk5z0pbrsmlprrfy0606h6yb2gc6v4v5lag81clzcrc93z";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
