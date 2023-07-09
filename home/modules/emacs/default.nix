# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "2d6180429c3082c45aab4d5f396bd90a035d6481";
      sha256 = "0yig5rydy0999an9nzb9c4qy40pig00g34ms1cwi3yx5nvnjji2q";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
