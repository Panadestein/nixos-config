# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "7a6b64602ce263f8d106a4974615360b858b23f9";
      sha256 = "1zah4indmvhv5dd20wggdgcv5zjl3w0jkgcwzb9dj0vn34d50qjp";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
