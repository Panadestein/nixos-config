# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "548ae52db62b5b7fdcafd4f4239ece89ec862440";
      sha256 = "12iqrsfhi1c3wwzsbsxmp10sndwvgy85q8rn9px0dds2q0n77kji";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
