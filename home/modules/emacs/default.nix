# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "52fd2cec893dfe819955192056eb48c9da1ac563";
      sha256 = "0727cswph8j1bcfsgi5glzwf2svg1bgq6n30xavr1yywspsmf57n";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
