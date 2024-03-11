# Home manager configuration
{ inputs, config, lib, pkgs, ... }:
let
  hm = inputs.home-manager.lib.hm;
in
{
  # Import home-manager modules
  imports = builtins.concatMap import [
    ../modules
  ];

  # User packages
  home.packages = with pkgs; [
    # General utilities
    any-nix-shell
    asciidoctor
    bat
    bc
    bottom
    brightnessctl
    calcurse
    ccls
    code-minimap
    cowsay
    dconf2nix
    dysk
    eza
    fd
    figlet
    fortune
    fzf
    grc
    htop
    lolcat
    nvtop-amd
    poppler_utils
    qemu
    ripgrep
    sd
    tmate
    tmux
    trayer
    ueberzugpp
    universal-ctags
    volumeicon
    xclip
    xdg-utils
    xdotool
    # Windowm manager utilities
    dmenu
    flameshot
    nitrogen
    picom
    xmobar
    # GTK packages
    arc-theme
    cairo
    glib
    gnome.gnome-calendar
    gnome.simple-scan
    gobject-introspection
    gtk3
    guake
    loupe
    # Xfce packages
    xfce.exo
    (xfce.thunar.override {
      thunarPlugins = [xfce.thunar-archive-plugin];
    })
    xfce.xfconf
    # Terminal based apps
    alacritty
    gdu
    ranger
    vivid
    yazi
    # Text editors
    neovim
    # Science
    avogadro2
    gnuplot
    graphviz
    maxima
    papis
    pymol
    # Office
    calibre
    crow-translate
    djvulibre
    evince
    libreoffice-fresh
    ltex-ls
    pandoc
    translate-shell
    xournalpp
    # Videos
    ffmpeg
    kooha
    mpv
    yt-dlp
    # Image editing
    gimp
    imagemagick
    inkscape
    pdftk
    povray
    # Programming utilities
    cmake
    fortls
    gh
    haskell-language-server
    hyperfine
    neovide
    nil
    nixfmt
    rust-analyzer
    shellcheck
    valgrind
    # Programming languages
    cbqn-standalone-replxx
    cargo
    chez
    clojure
    gcc
    gdb
    ghc
    gnumake
    jdk11
    leiningen
    mpich
    nodejs
    racket
    rustc
    sbcl
    uiua
    # Shells
    nushellFull
    xonsh
    # Advanced calculators
    fend
    frink
    numbat
    # Internet and communications
    brave
    firefox
    nixpkgs-stable.slack
    skypeforlinux
    tdesktop
    thunderbird
    whatsapp-for-linux
    zoom-us
    # Leisure (NES, SNES and N64)
    (retroarch.override {
      cores = with libretro; [
        mupen64plus
        nestopia
        snes9x
      ];
    })
    # Web
    bundler
    hugo
    # Latex
    texlive.combined.scheme-full
    # Spell checkers and dictionaries
    (aspellWithDicts (dicts: with dicts; [ en
                                           en-computers
                                           en-science
                                           es
                                           de
                                           fr
                                         ]))
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.de_DE
    hunspellDicts.en_US
    hunspellDicts.fr-moderne
    languagetool
    # Security
    (pass.withExtensions
      (exts: [
        exts.pass-otp
        exts.pass-import
        exts.pass-update
      ]))
    rofi-pass
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

  # VScode configuration
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ fortran-language-server ]);
  };

  # Rofi
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-file-browser ]; };
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "arthur";
    extraConfig = {
      modi = "window,drun,run,ssh,file-browser-extended";
    };
  };
  xdg.configFile."rofi/file-browser".source = ../dotfiles/rofi_browser;

  # Alacritty
  xdg.configFile."alacritty/alacritty.toml".source = ../dotfiles/alacritty.toml;
  programs.alacritty = {
    enable = true;
  };

  # Xmobar
  xdg.configFile."xmobar/.xmobarrc".source = ../dotfiles/xmobarrc;
  home.file.".xmonad/xpm/haskell_20.xpm".source = ../dotfiles/images/haskell_20.xpm;
  home.file.".xmonad/trayer_padding.sh".source = ../dotfiles/trayer_padding.sh;
  programs.xmobar = {
    enable = true;
  };

  # Vim and Neovim
  home.file.".vimrc".source = ../dotfiles/vimrc;
  xdg.configFile."nvim/init.vim".source = ../dotfiles/init.vim;

  # Ranger
  xdg.configFile."ranger/rc.conf".source = ../dotfiles/rc.conf;

  # Thunar
  xdg.configFile."xfce4/helpers.rc".source = ../dotfiles/helpers_xfce.rc;

  # Ipython
  home.file.".ipython/profile_default/ipython_config.py".source = ../dotfiles/ipython_config.py;

  # Matplotlib (ensure Qt backend)
  home.file.".config/matplotlib/matplotlibrc".source = ../dotfiles/matplotlibrc;

  # Papis
  home.file.".config/papis/config".source = ../dotfiles/config_papis;

  # Nushell
  home.file.".config/nushell/env.nu".source = ../dotfiles/env.nu;
  home.file.".config/nushell/config.nu".source = ../dotfiles/config.nu;

  # Xonsh
  home.file.".xonshrc".source = ../dotfiles/xonshrc;

  # Translate Shell
  xdg.configFile."translate-shell/init.trans".source = ../dotfiles/init.trans;
  home.file.".config/translate-shell/happiness.trans".source = ../dotfiles/happiness.trans;

  # Picom, disables if not using a WM
  services.picom = {
    enable = true;
    activeOpacity = 1.0;
    inactiveOpacity = 1.0;
    menuOpacity = 1.0;
    wintypes = {
      dock = { shadow = false; };
      dnd = { shadow = false; };
    };
    opacityRules = [
      "90:class_g = 'Alacritty'"
    ];
    backend = "glx";
  };

  # Extra Xsession config
  xsession = {
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = ../dotfiles/xmonad.hs;
      };
    };
  };

  # Pointer cursor
  home.pointerCursor = {
    x11.enable = true;
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 25;
  };

  # Qtile configuration
  xdg.configFile."qtile/config.py".source = ../dotfiles/config_qtile.py;
  home.file.".config/qtile/python_icon.png".source = ../dotfiles/images/python_icon.png;
  home.file.".config/qtile/tc_feyn.png".source = ../dotfiles/images/tc_feyn.png;
  home.file.".config/qtile/cc_tram.jpg".source = ../dotfiles/images/cc_tram.jpg;

  # Set LightDM avatar (https://wiki.archlinux.org/title/LightDM#Changing_your_avatar)
  home.file.".face".source = ../dotfiles/images/cfd_DWudN.png;

  # Script to control plugged monitors
  home.file.".config/scripts/randr_conf.sh".source = ../dotfiles/randr_conf.sh;

  # GTk theme, disabled if using Gnome
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 25;
    };
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  # Removable devices
  services.udiskie = {
    enable = false;
    tray = "always";
  };

  # State version
  home.stateVersion = "22.05";
}
