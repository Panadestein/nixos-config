# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "123f8d53781a02bfc25cb100e8d9ab640f3b0071";
      sha256 = "0yw9wpsz1b00yvbsz0iimppm2h1fa4rxvdm7k6m8vyrrl3iyyjyl"; 
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
