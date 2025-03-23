# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "9b5ed7b0df36c16dfcf0a2e161157a99b1fd341d";
      sha256 = "0rckyamq3y2yz53nhrz0bpqqgk4d3kdz3zmrp83gnqp4sdz00kl0";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
