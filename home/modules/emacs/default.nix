# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "28e92324a01c326c07301605f18ba1e668ff3096";
      sha256 = "147kqr801y477qkj35qbpvlqdghm0c4mdrnmnrzkr622awpq0yfc";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
