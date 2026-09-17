# Bash config
_: {
  programs.bash = {
    enable = true;
    enableCompletion = true;

    bashrcExtra = ''
      export LS_COLORS="$(vivid generate oehme)"
    '';

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
      n = "nvim";
      sb = "source ~/.bashrc";
      sv = "sudo nvim";
      t = "trans";
      v = "nvim";
      # Aliases for configuration files
      cde = "cd ~/.emacs.d/";
      cfb = "e ~/.bashrc";
      cfe = "e ~/.emacs.d/init.el";
      cfn = "nvim ~/.config/nvim/init.lua";
      vb = "nvim ~/.bashrc";
      vz = "nvim ~/.config/zsh/.zshrc";
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
  };
}
