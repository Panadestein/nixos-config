# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "d5c683cd17fe13b6b587ea3ad3df297bae22a731";
      sha256 = "16g4n8zny6gynjhlzjwdfk3lq7wjyi8g6dbvlxrzgn66vzmngx9g";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
