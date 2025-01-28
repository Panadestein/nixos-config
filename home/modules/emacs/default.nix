# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "3fcffff112d809507473a4bc299f47cd5d05358f";
      sha256 = "1hcki56354qsi18rvbk2l5czrlcddk2v6sxjvdlpqls08i71d9w9";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
