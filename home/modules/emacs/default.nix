# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "2c6767b2c395010cd0dd407b403ae2ef0f291fd0";
      sha256 = "13ipgfzhxwqljbdlczdlzk1f7z8azr0cin0dl5xh01kcpmmb8czw"; 
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
