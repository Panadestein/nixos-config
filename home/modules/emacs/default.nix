# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "8fbe44d982c41ef5e5265dcc7e062777a51b53d2";
      sha256 = "01c3qrg0ij89qb7g48bb2x21s7jsjsfij7ivmn041r20f6hh6b3d"; 
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
