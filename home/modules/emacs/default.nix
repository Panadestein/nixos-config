# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "07153f5f9ce2ab14de163672f6eccdd05e84119a";
      sha256 = "1iwplg2n3rcxmkzbp9203wzdj65vgcg71a9m2sqrlqlsbyj3a18c";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
