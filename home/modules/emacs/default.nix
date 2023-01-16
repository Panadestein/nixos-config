# Emacs configuration
{ config, pkgs, ... }:
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "a449b0e3c8b5c9062774550091c4399f07d71f99";
      sha256 = "0k2lg7csq7dgwn3r8r2qn4n9vd1fp49bvfb079gf4iy1qr832zxz"; 
    };
    recursive = true;
    onChange = builtins.readFile ../../dotfiles/set_emacs.sh;
  };
}
