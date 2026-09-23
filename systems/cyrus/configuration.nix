#-----------------------------
#    _   _ _       ___  ____
#   | \ | (_)_  __/ _ \/ ___|
#   |  \| | \ \/ / | | \___ \
#   | |\  | |>  <| |_| |___) |
#   |_| \_|_/_/\_\\___/|____/
#
#      Panadestein's NixOS
#-----------------------------

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  theme = import ../../home/theme.nix;
  hyprlandSession = pkgs.writeShellScript "hyprland-session" ''
    exec ${lib.getExe config.programs.uwsm.package} start -e -D Hyprland -g -1 hyprland.desktop >/dev/null 2>&1
  '';
in
{
  imports = [
    # Hardware of the current machine
    ./hardware-configuration.nix

    # Declarative GPT, LUKS, and Btrfs layout
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  # Overlays
  nixpkgs.overlays = [
    # Emacs overlay
    (import inputs.emacs-overlay)
  ];

  # Nixpkgs configuration
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      inxi = pkgs.inxi.override { withRecommends = true; };
    };
  };

  # Nix configuration
  nix = {
    optimise.automatic = true;
    settings = {
      accept-flake-config = true;
      auto-optimise-store = true;
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://cache.numtide.com"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
      trusted-users = [
        "root"
        "loren"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  boot = {
    # Set the linux kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # Kernel parameters and modules
    initrd = {
      kernelModules = [
        "amdgpu"
        "hid-apple"
      ];
      verbose = false;
    };
    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_level=3"
      "vt.global_cursor_default=0"
      "fbcon=nodefer"
      "hid_apple.fnmode=0"
      "psmouse.synaptics_intertouch=0"
    ];
    consoleLogLevel = 0;
    plymouth = {
      enable = true;
      extraConfig = "DeviceTimeout=5\n";
    };
    kernel.sysctl = {
      "kernel.printk" = "3 3 3 3";
    };

    # GRUB provides access to earlier generations if an upgrade fails to boot.
    loader = {
      timeout = 5;
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
  };

  # Load AMD CPU microcode and firmware
  hardware = {
    cpu.amd.updateMicrocode = true;
    firmware = [ pkgs.linux-firmware ];

    # Scanners
    sane = {
      enable = true;
      extraBackends = [
        pkgs.sane-airscan
      ];
    };

    # Bluetooth support
    bluetooth.enable = true;
  };

  systemd = {
    settings.Manager.ShowStatus = false;
    services = {
      NetworkManager-wait-online.enable = false;
      greetd.serviceConfig.Type = lib.mkForce "simple";
      plymouth-quit = {
        restartIfChanged = false;
        serviceConfig.ExecStart = [
          ""
          "-${pkgs.plymouth}/bin/plymouth quit --retain-splash"
        ];
      };
    };
    user.services = {
      nm-applet = {
        after = [ "graphical-session.target" ];
        wantedBy = lib.mkForce [ "graphical-session.target" ];
      };
      dropbox = {
        description = "Dropbox";
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.dropbox}/bin/dropbox";
          Restart = "on-failure";
          ProtectSystem = "full";
          Nice = 10;
        };
      };
      udiskie = {
        description = "Removable-media tray service";
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.udiskie}/bin/udiskie --tray";
          Restart = "on-failure";
        };
      };
    };

    # WireGuard & wgnord (NordVPN) directory & template provisioning
    tmpfiles.rules = [
      "d /etc/wireguard 0700 root root -"
      "d /var/lib/wgnord 0700 root root -"
      "C /var/lib/wgnord/template.conf 0600 root root - ${pkgs.writeText "wgnord-template.conf" ''
        [Interface]
        PrivateKey = PRIVKEY
        Address = 10.5.0.2/32
        MTU = 1350
        DNS = 103.86.96.100 103.86.99.100

        [Peer]
        PublicKey = SERVER_PUBKEY
        AllowedIPs = 0.0.0.0/0, ::/0
        Endpoint = SERVER_IP:51820
        PersistentKeepalive = 25
      ''}"
    ];
  };

  # Set hostname
  networking.hostName = "cyrus";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  programs = {
    # Set zsh as default shell
    zsh.enable = true;

    # Enable fish shell
    fish.enable = true;

    # NetworkManager tray applet
    nm-applet.enable = true;

    # Hyprland is the only graphical session. UWSM owns its systemd lifecycle.
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    dconf.enable = true;
    chromium = {
      enable = true;
      extraOpts = {
        BrowserThemeColor = theme.background;
        BrowserColorScheme = "device";
      };
      initialPrefs.browser.theme = {
        color_scheme = 0;
        color_scheme2 = 0;
      };
    };

    # Printing configuration UI
    system-config-printer.enable = true;

    # Run dynamically linked executables intended for conventional Linux systems.
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        zlib
        stdenv.cc.cc.lib
      ];
    };

    java.enable = true;

    # GnuPG agent
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  users.defaultUserShell = pkgs.zsh;

  # Network configuration
  networking = {
    nameservers = [
      "1.1.1.1"
      "9.9.9.9"
    ];
    networkmanager = {
      enable = true;
      wifi.powersave = lib.mkDefault false;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
    firewall = {
      checkReversePath = "loose";
      interfaces.wlp2s0 = {
        allowedTCPPorts = [ 53317 ];
        allowedUDPPorts = [ 53317 ];
      };
    };
  };

  # Select internationalization properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    # Fingerprint authentication
    fprintd.enable = true;

    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${hyprlandSession}";
          user = "loren";
        };
        default_session = {
          command = "${lib.getExe' pkgs.greetd "agreety"} --cmd ${lib.escapeShellArg "${hyprlandSession}"}";
          user = "greeter";
        };
      };
    };

    # Update UEFI and supported peripheral firmware through LVFS.
    fwupd.enable = true;

    # Printing support with CUPS and mDNS discovery
    printing = {
      enable = true;
      drivers = [
        pkgs.hplip
        pkgs.hplipWithPlugin
      ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    blueman.enable = true;

    # Emacs daemon
    emacs = {
      enable = true;
      package = pkgs.emacs-git-pgtk;
      defaultEditor = true;
    };

    # Audio service
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Desktop and system integration
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    openssh.enable = true;
    upower.enable = true;
    dbus.enable = true;
  };

  # Fingerprint authentication is exposed through PAM to greetd and Hyprlock.
  security = {
    pam.services = {
      greetd = {
        fprintAuth = true;
        enableGnomeKeyring = true;
      };
      hyprlock = {
        fprintAuth = true;
        enableGnomeKeyring = true;
      };
    };
    rtkit.enable = true;

    # Passwordless sudo for wgnord
    sudo.extraRules = [
      {
        users = [ "loren" ];
        commands = [
          {
            command = "${pkgs.wgnord}/bin/wgnord";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

  # User account and configuration
  users.users.loren = {
    isNormalUser = true;
    home = "/home/loren";
    createHome = true;
    extraGroups = [
      "wheel"
      "audio"
      "input"
      "docker"
      "networkmanager"
      "systemd-journal"
      "video"
      "scanner"
      "lp"
    ];
  };

  # Global packages, minimal to avoid polluting environment
  environment.systemPackages = with pkgs; [
    # General utilities
    acpi
    binutils
    cacert
    coreutils
    curl
    dmidecode
    file
    git
    inxi
    iw
    killall
    libtool
    pavucontrol
    pciutils
    rsync
    sshfs
    unrar
    unzip
    usbutils
    wget
    which
    wgnord
    wireguard-tools
    # Terminal and CLI utilities
    zsh
    inputs.papis.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Text editors and office
    emacs-git-pgtk
    # Programming languages (here to avoid environment clashes)
    (
      let
        my-python-packages =
          python-packages: with python-packages; [
            # Scientific libraries
            jupyter
            matplotlib
            mpmath
            numpy
            pandas
            scikit-learn
            scipy
            sympy
            # LSP and linters
            ruff
            autopep8
            flake8
            mypy
            pydocstyle
            pylint
            # Backends
            pyqt6
          ];
        python-with-my-packages = python3.withPackages my-python-packages;
      in
      python-with-my-packages
    )
    uv
  ];

  # Wayland electron apps
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    COLORTERM = "truecolor";
  };

  # Fonts
  fonts.packages = with pkgs; [
    dina-font
    fira-code
    fira-code-symbols
    font-awesome
    inter
    iosevka
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    proggyfonts
    source-code-pro
    uiua386
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    emacs-all-the-icons-fonts
  ];
  fonts.fontconfig.defaultFonts = {
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

  # Virtualization setup, only docker at the moment
  virtualisation = {
    docker = {
      enable = true;
      extraOptions = "--default-ulimit nofile=65536:65536";
    };
  };

  # State version
  system.stateVersion = "26.05";
}
