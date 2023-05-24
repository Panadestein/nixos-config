# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "d4e9f2e18091fde0916d09aebdb70b93d5242037";
      sha256 = "07d8wrk4mq7h8gjkic79miw7xrksypff4kj1sm1v0w7mv2l31mx8";
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
