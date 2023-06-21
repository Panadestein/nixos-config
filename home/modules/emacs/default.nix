# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "a2e98b0b9549350587bde16960def496316d929d";
      sha256 = "1gplrmyl3hcma0fyiv5yfq1qz485v0p1m7k3xrr2npidx12rcrdb";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
