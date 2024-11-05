# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "c4de52cb95e997a35595a191370587da22b9987d";
      sha256 = "1239q8sspvr8vqn7wc3af0xm7sbyaw8lglgrr8ksp29y1vhw6c1q";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
