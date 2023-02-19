# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "82c318c0ef1ca91e54df3cc819f7cff32a59c16b";
      sha256 = "061k0w46mkbnxq90hwx9302ylp47gyh2scfqsf97xwddy3qf4smq";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
