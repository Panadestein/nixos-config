# Emacs configuration
{
  home.file.".emacs.d/" = {
    source = pkgs.fetchFromGitHub {
      owner = "Panadestein";
      repo = "emacsd";
      rev = "0c7c69d24887ef3dfb34bd1b3e96671c0c322c8b";
      # nix-prefetch-url --unpack https://github.com/Panadestein/emacsd/archive/rev.tar.gz
      sha256 = "12kx7mw9a66ppxcr45w7bhhdxkddgva5sy86pcpbh1np6pxwcw40"; 
    };
    recursive = true;
    onChange = builtins.readFile ../dotfiles/set_emacs.sh;
  };
}
