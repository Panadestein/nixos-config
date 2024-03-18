# Zsh config
{ config, lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;

    shellAliases = {
      # General aliases
      c = "code -r";
      cow = "fortune | cowsay";
      e = "emacsclient";
      E = "SUDO_EDITOR='emacsclient -t -a emacs' sudoedit";
      en = "emacsclient -c -nw";
      jour1 = "journalctl -p 3 -xb";
      jour2 = "journalctl -xb | grep rror";
      ka = "killall";
      n = "neovide --maximized";
      r = "ranger";
      sb = "source ~/.bashrc";
      sv = "sudo nvim";
      sz = "source ~/.zshrc";
      t = "trans";
      v = "nvim";
      xo = "xonsh";
      # Aliases for configuration files
      cde = "cd ~/.emacs.d/";
      cfb = "e ~/.bashrc";
      cfe = "e ~/.emacs.d/init.el";
      cfn = "neovide --maximized ~/.config/nvim/init.vim";
      cfv = "vim ~/.vimrc";
      vb = "nvim ~/.bashrc";
      vz = "nvim ~/.zshrc";
      # Less frequently used aliases
      jnb = "jupyter notebook";
      starwars = "telnet towel.blinkenlights.nl";
      wo = ''figlet -t "$(hostname)" | lolcat'';
      meteo = "curl http://wttr.in";
      # Aliases for remote machines
      ccpgate = "ssh -Y panades@ccpgate.tnw.utwente.nl";
      jul = "ssh -i ~/.ssh/id_ed25519 -Y panadesbarrueta1@juwels-cluster.fz-juelich.de";
      lsts0 = "ssh -Y rbarrueta@141.30.9.190";
      lsts1 = "ssh -Y rbarrueta@141.30.9.191";
      mah = "ssh rpanades@mahti.csc.fi";
      pader = "ssh -t -i ~/.ssh/id_rsa corexl01@sshgate.uni-paderborn.de";
      sakup = "sftp ramon@sakura.univ-lille1.fr";
      sakura = "ssh -Y ramon@sakura.univ-lille1.fr";
      sssara = "ssh -Y panades@doornode.surfsara.nl";
      tau = "ssh -Y rapa157d@taurus.hrsk.tu-dresden.de";
      toul = "ssh panades@lpqsv11.ups-tlse.fr";
      tukup = "sftp rbarrueta@cpch06.chm.tu-dresden.de";
      tume = "ssh -Y rbarrueta@cpch06.chm.tu-dresden.de";
    };

    history = {
      expireDuplicatesFirst = true;
      size = 10000000;
    };

    initExtra = builtins.readFile ../../dotfiles/zshextra;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "command-not-found"
        "git"
        "history"
        "sudo"
      ];
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
      ];
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };
}
