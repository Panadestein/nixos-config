# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "201c8ee060b2a101a0c5db71730ed7bc022c37fa";
      sha256 = "1llgfk5rxpbmwvvy3xi0gzmqbwc271c9bg4jkwpzrn2h0w0xwk20";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
