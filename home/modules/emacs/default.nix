# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "5826d3deaf7eff571fbc4212352a9edba159b6eb";
      sha256 = "102665nmf32r8mqvsgczzwaqwhvqb47bh025izx046f05f8pwlbl";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
