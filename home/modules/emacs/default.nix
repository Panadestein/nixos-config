# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "69da3c218058c038c18e8af0e6f93fa5e9403074";
      sha256 = "17xf0lws6js77x5sl97drsyq40jd5x6w9rxb304nfgcwl3s5zfis";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
