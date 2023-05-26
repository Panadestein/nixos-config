# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "bc927b783334c7004e13b39f126c0df43990e662";
      sha256 = "179f3xjg9awgq0b5h22yncdrg7jbsbg9lw03i4ffcs2j87vi2s05";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
