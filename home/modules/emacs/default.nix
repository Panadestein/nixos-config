# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "f5cec1705391a43ee7efa6f14a27072fb3b6f455";
      sha256 = "0s75x517scdb501zgw93k18vz3yf13irq88gk1cadhwsmhxxaj6h";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
