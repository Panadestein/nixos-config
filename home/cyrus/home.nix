# Home manager configuration
{ inputs, config, lib, pkgs, ... }:
let
  hm = inputs.home-manager.lib.hm;
  cbqn = pkgs.callPackage ../modules/cbqn/default.nix { };
  bqn386_git = pkgs.callPackage ../modules/bqn386/default.nix { };
  grr = pkgs.callPackage ../modules/grr/default.nix { };
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
    awscli
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
    nvtopPackages.amd
    poppler-utils
    qemu
    ripgrep
    sd
    step-cli
    tmate
    tmux
    trayer
    tree
    nix-prefetch-git
    nixpkgs-stable.ueberzugpp
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
    gnome-calendar
    gobject-introspection
    gtk3
    guake
    loupe
    simple-scan
    # Xfce packages
    xfconf
    exo
    (thunar.override {
      thunarPlugins = [thunar-archive-plugin];
    })
    # Terminal based apps
    alacritty
    gdu
    ranger
    vivid
    # Text editors
    neovim
    # Science
    gnuplot
    graphviz
    # Office
    calibre
    crow-translate
    djvulibre
    evince
    libreoffice
    ltex-ls
    pandoc
    readeck
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
    # Programming utilities
    cmake
    fortls
    gh
    grr
    haskell-language-server
    hotspot
    hyperfine
    mob
    mpi
    neovide
    nil
    nixfmt-classic
    openblas
    perf
    ride
    rust-analyzer
    samply
    shellcheck
    valgrind
    # Programming languages
    cargo
    cbqn
    chez
    chicken
    clojure
    (dyalog.override {acceptLicense = true;})
    gcc
    gdb
    ghc
    gnumake
    jdk11
    julia-bin
    lean4
    leiningen
    nodejs
    octave
    racket
    rustc
    sbcl
    uiua
    # Shells
    nushell
    xonsh
    # Advanced calculators
    fend
    frink
    numbat
    # Internet and communications
    brave
    firefox
    google-chrome
    slack
    telegram-desktop
    thunderbird
    wasistlos
    # Leisure (NES, SNES and N64)
    (retroarch.withCores (
      cores: with libretro; [
        mupen64plus
        nestopia
        snes9x
      ]
    ))
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
    # Fonts
    bqn386_git
    # Security
    (pass.withExtensions
      (exts: [
        exts.pass-otp
        exts.pass-import
        exts.pass-update
      ]))
    rofi-pass
  ];

  # Make sure fontconfig gets updated
  fonts.fontconfig.enable = true;

  # Nix CLI helper
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--delete-older-than 7d";
    };
  };

  # Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Panadestein";
        email = "rpana92@gmail.com";
      };
      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
      }/bin/git-credential-libsecret";
    };
  };

  # VScode configuration
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ fortran-language-server ]);
  };

  # Rofi
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "arthur";
    extraConfig = {
      modi = "window,drun,run,ssh";
    };
  };

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

  # Picom, disable if not using a WM
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
    vSync = true;
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
    package = pkgs.adwaita-icon-theme;
    size = 25;
  };

  # Qtile configuration
  xdg.configFile."qtile/config.py".source = ../dotfiles/config_qtile.py;
  home.file.".config/qtile/python_icon.png".source = ../dotfiles/images/python_icon.png;
  home.file.".config/qtile/bqn_logo.png".source = ../dotfiles/images/bqn_logo.png;
  home.file.".config/qtile/fish_logo.png".source = ../dotfiles/images/fish_logo.png;
  home.file.".config/qtile/tc_feyn.png".source = ../dotfiles/images/tc_feyn.png;
  home.file.".config/qtile/PiN_EFOehme.jpg".source = ../dotfiles/images/PiN_EFOehme.jpg;
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
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
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
