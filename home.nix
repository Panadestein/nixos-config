# Home manager configuration

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.loren = {
    home.packages = [
      pkgs.brightnessctl
      pkgs.gnome.nautilus
      pkgs.chicken
      pkgs.inkscape
      pkgs.imagemagick
      pkgs.gimp
      pkgs.gnome.eog
      pkgs.neovide
      pkgs.guake
      pkgs.tdesktop
      pkgs.skype
      pkgs.zoom
      pkgs.libreoffice
    ];

    # Git
    programs.git = {
      enable = true;
      userName = "Panadestein";
      userEmail = "rpana92@gmail.com";
      extraConfig = {
        credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";};
    };

    # Rofi
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      theme = "arthur";
    };

    # Alacritty
    xdg.configFile."alacritty/alacritty.yml".source = ./dotfiles/alacritty.yml;
    programs.alacritty = {
      enable = true;
    };

    # Xmobar
    xdg.configFile."xmobar/.xmobarrc".source = ./dotfiles/.xmobarrc;
    programs.xmobar = {
      enable = true;
    };

    # Picom
    services.picom = {
      enable = true;
      activeOpacity = "1.0";
      inactiveOpacity = "0.8";
      backend = "glx";
    };

    # Extra Xsession config
    xsession = {
      pointerCursor = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 25;
      };
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = ./dotfiles/xmonad.hs;
      };
    };

    # GTk theme
    gtk = {
      enable = true;
      iconTheme = {
        name = "elementary";
        package = pkgs.pantheon.elementary-icon-theme;
      };
      theme = {
        name = "Arc-Darker";
        package = pkgs.arc-theme;
      };
    };

    # Removable devices
    services.udiskie = {
      enable = true;
      tray = "always";
    };

    # Zsh config
    programs.zsh = {
      enable = true;
      autocd = true;
      dotDir = ".config/zsh";
      enableAutosuggestions = true;
      enableCompletion = true;

      shellAliases = {
        # General aliases
        e = "emacsclient";
        E = "SUDO_EDITOR='emacsclient -t -a emacs' sudoedit";
        v = "nvim";
        n = "neovide --maximized";
        r = "ranger";
        sbl = "subl";
        sb = "source ~/.bashrc";
        sz = "source ~/.zshrc";
        ka = "killall";
        sv = "sudo nvim";
        jour1 = "journalctl -p 3 -xb";
        jour2 = "journalctl -xb | grep rror";
        # Aliases for configuration files
        cfb = "e ~/.bashrc";
        vb = "nvim ~/.bashrc";
        vz = "nvim ~/.zshrc";
        cfe = "e ~/.emacs.d/init.el";
        cde = "cd ~/.emacs.d/";
        cfv = "vim ~/.vimrc";
        cfn = "neovide --maximized ~/.config/nvim/init.vim";
        # Less useful aliases
        wo = ''figlet -t "$(hostname)"'';
        nf = "clear && neofetch";
        jnb = "jupyter notebook";
        mopac = "/home/rpanades/bin/MOPACMINE/MOPAC2016.exe";
        unix72 = "docker run --rm -it bahamat/unix-1st-ed";
        starwars = "telnet towel.blinkenlights.nl";
        # Aliases for remote machines
        sakura = "ssh -Y ramon@sakura.univ-lille1.fr";
        sssara = "ssh -Y panades@doornode.surfsara.nl";
        ccpgate = "ssh -Y panades@ccpgate.tnw.utwente.nl";
        tau = "ssh -Y rapa157d@taurus.hrsk.tu-dresden.de";
        tume = "ssh -Y rbarrueta@cpch06.chm.tu-dresden.de";
        lsts0 = "ssh -Y rbarrueta@141.30.9.190";
        lsts1 = "ssh -Y rbarrueta@141.30.9.191";
        tukup = "sftp rbarrueta@cpch06.chm.tu-dresden.de";
        sakup = "sftp ramon@sakura.univ-lille1.fr";
        toul = "ssh panades@lpqsv11.ups-tlse.fr";
      };

      history = {
        expireDuplicatesFirst = true;
        size = 10000000;
      };

      initExtra = ''
      source /etc/nixos/dotfiles/zshextra
      '';

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
            rev = "v0.4.0";
            sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
          };
        }
      ];
    };
  };
}

