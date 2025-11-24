# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "6b9db2e7325b15cbee0d277f90ad527e316a57a0";
      sha256 = "0yy5jc313j8krcyf17ddq510zfz78l1763vibblqclb2qxi69r86";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
