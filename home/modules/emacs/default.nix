# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "bb40038e71c25e8c7d6aed4d6c642fce6d2e8b2b";
      sha256 = "1qibnwkivhnxn4ns7rg2ljb7ys7rm9d9wzxyhhcwq5qwxg3ygwl4";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
