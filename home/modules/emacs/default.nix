# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "a93a3e4ecb2ce7f7f57896b1b295a8e295915e0a";
      sha256 = "128ld3avyz8h4xklw3hk52xwa3qn7vxmf4yhjh3im32f47vsdxw1";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
