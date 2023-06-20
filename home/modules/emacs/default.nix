# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "4f22f7bf3d74694a3e9869afb31cebb83f10125c";
      sha256 = "1r3v3cwnxa2bgwd40a31x0y9nl1pdwjq98z7p00fvxd5sdw1hjxb";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
