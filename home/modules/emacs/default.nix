# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "16640454d310f4d0d4a2fe51debc08126b13d76c";
      sha256 = "04kfj00zbvxgqq3naccyxris03arw4v3k8jy69xbi2dgf199izin";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
