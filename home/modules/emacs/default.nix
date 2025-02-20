# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "1fe80f7c0049e224be63cac9087f293d26618ea2";
      sha256 = "00acw9swxbl51g6w977fywmnpmyhx5b5kajh80jjgzgqcqv43c5y";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
