# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "95732f60e0560157d475a699f80e101ca3acb4a3";
      sha256 = "01fkiqq9wm1rpjh2bzfadw59nf283a3gw9hf3gm01n8dm7qpmayl";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
