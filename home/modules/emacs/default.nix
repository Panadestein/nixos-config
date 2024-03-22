# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "07d78be2b8d41b34936ecfce3f2c9e67442ff53f";
      sha256 = "0whgc8ljarm0nl1l2ky42jg9kzxmywd76hpxn03f0v1avvsd47vh";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
