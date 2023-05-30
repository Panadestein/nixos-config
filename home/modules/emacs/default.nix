# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "1e2e0fe4e8c9e39982d41c2653ca23f0224ea677";
      sha256 = "1krc77jskzv4bvcz0vz1rkn1li68i3sxc02ayf3x6sf4ac7p7rcv";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
