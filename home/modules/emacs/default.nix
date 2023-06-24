# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "2661af1be007dc63292da8f761d6436bf32ae906";
      sha256 = "1lnyswc6cfqg6qsciys8jjxwx2s26qq5a4z6kcaav3yizygdrqmx";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
