# Home manager configuration
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  cbqn_complex = inputs.cbqn-complex.packages.${pkgs.stdenv.hostPlatform.system}.default;
  bqn386_git = pkgs.callPackage ../modules/bqn386/default.nix { };
  theme = import ../theme.nix;
  wallpaperSource = ../wallpapers/oehme;
in
{
  dconf.enable = true;

  # Import home-manager modules
  imports = builtins.concatMap import [
    ../modules
  ];

  # User packages
  home.packages = with pkgs; [
    # General utilities
    any-nix-shell
    asciidoctor
    awscli2
    bat
    bc
    btop
    brightnessctl
    ccls
    code-minimap
    cowsay
    dysk
    eza
    fd
    figlet
    fortune
    fzf
    grc
    jq
    lolcat
    nvtopPackages.amd
    poppler-utils
    qemu
    ripgrep
    sd
    step-cli
    tealdeer
    tmate
    tmux
    tree
    nix-prefetch-git
    universal-ctags
    udiskie
    waypaper
    wf-recorder
    wl-clipboard
    xdg-utils
    yaru-theme
    dropbox-cli
    # GTK packages
    cairo
    glib
    gobject-introspection
    gtk3
    loupe
    nautilus
    papers
    # Terminal based apps
    gdu
    # Science
    gnuplot
    graphviz
    # Office
    crow-translate
    djvulibre
    libreoffice
    ltex-ls
    pandoc
    xournalpp
    # Videos
    ffmpeg
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
    haskell-language-server
    hotspot
    hyperfine
    mob
    mpi
    nil
    nixfmt
    openblas
    perf
    rust-analyzer
    samply
    shellcheck
    valgrind
    # Programming languages
    cargo
    cbqn_complex
    chicken
    clojure
    gcc
    gdb
    ghc
    gnumake
    jdk11
    nodejs
    racket
    rustc
    sbcl
    # Advanced calculators
    numbat
    # Internet and communications
    firefox
    localsend
    signal-desktop
    (slack.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        substituteInPlace $out/share/applications/slack.desktop \
          --replace-fail 'Exec=' 'Exec=env GTK_THEME=Yaru-dark '
      '';
    }))
    telegram-desktop
    thunderbird
    # Leisure (NES, SNES and N64)
    (retroarch.withCores (
      _: with libretro; [
        nestopia
        snes9x
      ]
    ))
    # Web
    bundler
    hugo
    # Latex
    texliveFull
    # Spell checkers and dictionaries
    (aspellWithDicts (
      dicts: with dicts; [
        en
        en-computers
        en-science
        es
        de
        fr
      ]
    ))
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    hunspellDicts.fr-moderne
    languagetool
    # Fonts
    bqn386_git
    inter
    nerd-fonts.jetbrains-mono
  ];

  # Make sure fontconfig gets updated
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [
        "Inter"
        "Noto Sans"
      ];
      serif = [
        "Noto Serif"
        "Liberation Serif"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # Nix CLI helper
  programs.nh = {
    enable = true;
    flake = "/home/loren/.config/nixos";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 7d";
    };
  };

  # Per-project development environments
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      dark = true;
      navigate = true;
    };
  };

  # Plain Chromium; its Oehme color and dark/light behavior are set by the
  # system policy alongside the rest of the desktop theme.
  programs.chromium.enable = true;

  # Git
  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      user = {
        name = "Panadestein";
        email = "rpana92@gmail.com";
      };
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
    };
  };

  # VScode configuration
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ fortran-language-server ]);
  };

  # Native Wayland application launcher and window switcher
  programs.rofi = {
    enable = true;
    # Wayland support is merged into the main Rofi package in current nixpkgs.
    package = pkgs.rofi;
    terminal = "${pkgs.ghostty}/bin/ghostty";
    font = "Inter 12";
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          background = mkLiteral theme.background;
          background-alt = mkLiteral theme.lighterBackground;
          foreground = mkLiteral theme.foreground;
          selected = mkLiteral theme.selection;
          accent = mkLiteral theme.accent;
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@foreground";
        };
        window = {
          width = mkLiteral "720px";
          border = mkLiteral "2px";
          border-color = mkLiteral "@selected";
          border-radius = mkLiteral "14px";
          background-color = mkLiteral "@background";
          padding = mkLiteral "18px";
        };
        mainbox = {
          children = map mkLiteral [
            "inputbar"
            "listview"
          ];
          spacing = mkLiteral "14px";
        };
        inputbar = {
          children = map mkLiteral [ "entry" ];
          background-color = mkLiteral "@background-alt";
          border-radius = mkLiteral "9px";
          padding = mkLiteral "12px";
          spacing = mkLiteral "10px";
        };
        entry = {
          placeholder = "";
        };
        listview = {
          columns = 1;
          lines = 9;
          fixed-height = false;
          scrollbar = false;
          spacing = mkLiteral "5px";
        };
        element = {
          border-radius = mkLiteral "8px";
          padding = mkLiteral "10px";
          spacing = mkLiteral "12px";
        };
        "element selected.normal" = {
          background-color = mkLiteral "@selected";
          text-color = mkLiteral theme.brightForeground;
        };
        "element-icon" = {
          size = mkLiteral "28px";
        };
        "element-text" = {
          vertical-align = mkLiteral "0.5";
        };
      };
    extraConfig = {
      modi = "window,drun,run,ssh";
      icon-theme = "Yaru-blue-dark";
      show-icons = true;
      drun-display-format = "{name}";
    };
  };

  # Yazi
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };

  # Keep one active display: the external Lenovo while docked, otherwise the
  # laptop panel. Explicit modes select each panel's highest resolution.
  services.kanshi = {
    enable = true;
    systemdTarget = "wayland-session@hyprland.desktop.target";
    settings = [
      {
        output = {
          criteria = "Lenovo Group Limited T27h-30 V5PDV327";
          alias = "lenovoT27h";
        };
      }
      {
        profile = {
          name = "mobile";
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              mode = "1920x1200@60.10Hz";
              position = "0,0";
              scale = 1.25;
            }
          ];
        };
      }
      {
        profile = {
          name = "lenovo-docked";
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "$lenovoT27h";
              status = "enable";
              mode = "2560x1440@59.95Hz";
              position = "0,0";
              scale = 1.25;
            }
          ];
        };
      }
    ];
  };

  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      background-color = theme.background;
      border-color = theme.accent;
      border-radius = 8;
      border-size = 2;
      default-timeout = 5000;
      font = "Inter 11";
      text-color = theme.foreground;
    };
  };

  # Pointer cursor
  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 25;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    cursor-theme = "Adwaita";
    cursor-size = 25;
    font-name = "Inter 11";
    gtk-theme = "Yaru-dark";
    icon-theme = "Yaru-blue-dark";
    monospace-font-name = "JetBrainsMono Nerd Font 11";
    text-scaling-factor = 1.3636;
  };

  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Yaru-dark
    gtk-icon-theme-name=Yaru-blue-dark
    gtk-cursor-theme-name=Adwaita
    gtk-cursor-theme-size=25
    gtk-font-name=Inter 11
    gtk-application-prefer-dark-theme=1
  '';
  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Yaru-dark
    gtk-icon-theme-name=Yaru-blue-dark
    gtk-cursor-theme-name=Adwaita
    gtk-cursor-theme-size=25
    gtk-font-name=Inter 11
    gtk-application-prefer-dark-theme=1
    gtk-interface-color-scheme=2
  '';

  # Present the repository-tracked paintings as one user-facing gallery.
  xdg.dataFile."wallpapers/oehme".source = wallpaperSource;

  # Icon assets and fallbacks
  xdg.dataFile."icons/hicolor/256x256/apps/preferences-system.png".source =
    "${pkgs.yaru-theme}/share/icons/Yaru/256x256/apps/preferences-system.png";
  xdg.dataFile."icons/hicolor/256x256/apps/preferences-system-network.png".source =
    "${pkgs.yaru-theme}/share/icons/Yaru/256x256/categories/preferences-system-network.png";

  # Desktop entries for applications with missing or launcher-incompatible icons
  xdg.desktopEntries = {
    nm-connection-editor = {
      name = "Advanced Network Configuration";
      comment = "Manage and change your network connection settings";
      icon = "preferences-system-network";
      exec = "nm-connection-editor";
      terminal = false;
      categories = [
        "GNOME"
        "GTK"
        "Settings"
        "X-GNOME-NetworkSettings"
      ];
    };
    uuctl = {
      name = "uuctl";
      genericName = "User unit manager";
      comment = "Select and perform actions on user systemd units";
      icon = "preferences-system";
      exec = "uuctl";
      terminal = false;
      categories = [
        "Utility"
        "Settings"
      ];
    };
  };

  # Default MIME applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = [ "emacsclient.desktop" ];
      "text/markdown" = [ "emacsclient.desktop" ];
      "text/org" = [ "emacsclient.desktop" ];
      "x-scheme-handler/org-protocol" = [ "emacsclient.desktop" ];
      "application/pdf" = [ "org.gnome.Papers.desktop" ];
      "application/x-bzpdf" = [ "org.gnome.Papers.desktop" ];
      "application/x-gzpdf" = [ "org.gnome.Papers.desktop" ];
      "application/x-xzpdf" = [ "org.gnome.Papers.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "image/webp" = [ "org.gnome.Loupe.desktop" ];
      "image/gif" = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "application/x-gnome-saved-search" = [ "org.gnome.Nautilus.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      "x-scheme-handler/slack" = [ "slack.desktop" ];
      "x-scheme-handler/antigravity" = [ "antigravity.desktop" ];
      "x-scheme-handler/claude-cli" = [ "claude-code-url-handler.desktop" ];
    };
  };

  # State version
  home.stateVersion = "22.05";
}
