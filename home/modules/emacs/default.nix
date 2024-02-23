# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "127291b5858a74ac6ea88f862d6ed3b7cd4933ec";
      sha256 = "1yb4wsabvxxkk0bzhdi0pj4lh5594d78whjdawsa9bm1bfd0izpp";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
