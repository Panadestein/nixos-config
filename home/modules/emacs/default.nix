# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "fdc6ecf5a05a710232295282a286954cce42cfd3";
      sha256 = "0izljv5r3mda5w1xj5l7s718rwyr2pcwajl3zmkxwnaiw0bc8g44"; 
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
