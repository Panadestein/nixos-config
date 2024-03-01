# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "b40a7778812eaeb1325033dc2f195895a7c9f52e";
      sha256 = "0a15yxi5hxfr0ja1wl10cyb11d7jh27wd0kma6q7yyng4n0qvvhf";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
