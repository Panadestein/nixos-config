# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "3527cd5a23558e6c3594915b0f1dfa1ab2720f44";
      sha256 = "1xna9vmx9vqqxk7i8qwbzhld599jfi7gb36d5x0jczyg9b788gcd"; 
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
