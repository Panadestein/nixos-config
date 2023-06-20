# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "4c0e0e3399abdc09726b5e90c066cf65be94b174";
      sha256 = "1f6ba8kp4znz2r7lksh2l4yr9b4sfsx19lvasicf0kbfv0xz7zni";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
