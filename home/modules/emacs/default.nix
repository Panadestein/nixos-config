# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "cb9c36f6d7735ea445112564d847fb067a221fe7";
      sha256 = "0jyqsv3dyqra8l656m604535fsk6fqc5fmscvpqsc5saxz3kwxlk";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
