# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "0493a88aa00240a8cd0acad92116fe0198463d4c";
      sha256 = "0fg11ji1w9yhc6200ln881kfmllpq99mkbwsf1p4kvv9a7ikpfx6"; 
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
