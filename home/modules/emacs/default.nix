# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "28c587430563385b5f3bf454e27c7d8c052a6edd";
      sha256 = "178v733k8wnyk5l7fz8ysispy7wiwaq8x0kyvc7jdy1rmga2agz2";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
