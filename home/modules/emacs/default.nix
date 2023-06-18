# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "30df499337f02a71a9177bf63129913d856dbce3";
      sha256 = "1y1gddyb9vaqxr86ppw2309zsqnqrphqqfva4yyvvrdx3hnc39ll";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
