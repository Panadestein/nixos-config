# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "4510abe11279488d3f36b3844cffed7cbbba784e";
      sha256 = "0c67j9p929n22inkc1n46mw55fbgkss59dv951xpwzvq2zlqcksv";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
