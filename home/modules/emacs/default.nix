# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "194acf09f0d34db10977b49630f0bbe26b234c79";
      sha256 = "0kbihdxv7isr5iziqmqcqkjyg2p87ar4rc8rl9c8jmci7r9jswds";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
