# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "0bca934fbe61dd7cb408b857da6607d1a80c326b";
      sha256 = "159sywak0fb5wc84ngfdl045xfasabdk176f25d8mbi80knlf1z3"; 
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
