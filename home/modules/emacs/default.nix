# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "91c609d472e9fcdb8995433840e0d4b33ff47454";
      sha256 = "01gk1rxafx2xnqa0f40qzw2dwqgl6yx0n5jpzg9sz2qadh24dbg0";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
