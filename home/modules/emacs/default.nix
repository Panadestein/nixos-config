# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "0c6bfefe26a4c9533677b72d8a82aa19b0d8a272";
      sha256 = "0z6idfz2li7iqyh37lp8v348nk5a0lhhwff7chq6k928sxfzi83r";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
