# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "3603d883dfe5a9ff77bcf95f1da401141c634945";
      sha256 = "09zcdfn8sh1kvwwfkh9p33r1x1mh09j9fhxllrzvf2j9yb3l64xf";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
