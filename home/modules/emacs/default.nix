# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "be8bf75ae12982bfdd990317fbe58fc61a34b5b7";
      sha256 = "1k5699hm663q3bikch53mn8hz4b7a1digsaqwvm610n1cqb9ybpw"; 
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
