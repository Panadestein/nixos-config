# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "e8f748cdaf5384486123ff38d5088bbeb8ed63ab";
      sha256 = "0bzmc20w0j9qqsdlr7xay9lws0fmig9m3x7lnbw0xic8m0sz6xq5";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
