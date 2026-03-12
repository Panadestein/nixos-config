# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "4b790d3642f7d0b15520bd45be40ad7c15ec955c";
      sha256 = "1whfhbnpzymz5my0w3qjg76ng3j0ra4r34pdsgi9p4cv4izwv2g0";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
