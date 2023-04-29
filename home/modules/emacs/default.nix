# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "0d14070198d561094acf6983579635ff914745a2";
      sha256 = "060wa3061364adm732a19vzh7xrqd3qmzbf3nm33vq2a05wqh6pz";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
