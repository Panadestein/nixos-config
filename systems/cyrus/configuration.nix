#-----------------------------
#    _   _ _       ___  ____  
#   | \ | (_)_  __/ _ \/ ___| 
#   |  \| | \ \/ / | | \___ \ 
#   | |\  | |>  <| |_| |___) |
#   |_| \_|_/_/\_\\___/|____/ 
#
#      Panadestein's NixOS
#-----------------------------

{ config, pkgs, lib, inputs, ... }:
{
  imports =
    [
      # Hardware of current machine
      ./hardware-configuration.nix
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
    settings = {
      substituters = [
        "https://nix-community.cachix.org/"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [
        "root"
        "loren"
      ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Use the latest linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Load AMD CPU microcode and firmware
  hardware.cpu.amd.updateMicrocode = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # And this is when you give up (for now)
  boot.blacklistedKernelModules = [
    "ath11k_pci"
  ];

  # Kernel parameters and modules
  boot.initrd.kernelModules = [ "amdgpu" "hid-apple"];
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "rd.systemd.show_status=auto"
    "rd.udev.log_level=3"
    "hid_apple.fnmode=0"
    "psmouse.synaptics_intertouch=0"
  ];
  boot.initrd.verbose = false;
  boot.plymouth.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub.enable = true;
    grub.efiSupport = true;
    grub.device = "nodev";
  };

  # Set hostname
  networking.hostName = "cyrus";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Set zsh as default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Enable fish shell
  programs.fish.enable = false;

  # Network configuration
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = lib.mkDefault false;
    };
  };
  programs.nm-applet.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure AMD graphics
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];
  services.xserver.deviceSection = ''Option "TearFree" "true"'';

  # Display manager
  services.xserver.displayManager = {
    gdm = {
      enable = false;
      wayland = true;
    };
    lightdm = {
      enable = true;
      greeters.enso = {
        enable = true;
      }; 
    };
  };
  services.displayManager.defaultSession = "none+qtile";

  # Window managers
  services.xserver.windowManager = {
    xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
      ];
    };
    qtile = {
      enable = true;
      package = pkgs.python3Packages.qtile;
    };
    stumpwm = {
      enable = false;
    };
  };
  
  # Desktop environment
  services.xserver.desktopManager.gnome.enable = false;
  xdg.portal.enable = lib.mkIf
    (!config.services.xserver.desktopManager.gnome.enable)
    true;
  xdg.portal.configPackages = lib.mkIf
    (!config.services.xserver.desktopManager.gnome.enable)
    [ pkgs.xdg-desktop-portal-gtk ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,bqn,de";
    options = "grp:rctrl_switch";
  };

  # Printing support with CUPS
  services.printing = {
    enable = true;
    drivers = [
      pkgs.hplip
      pkgs.hplipWithPlugin
    ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  programs.system-config-printer.enable = true;

  # Scanners
  hardware.sane.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  nixpkgs.config.pulseaudio = true;
  sound.mediaKeys.enable = true;

  # Bluetooth support
  hardware.bluetooth = {
    enable = true;
  };
  services.blueman.enable = true;

  # Enable touchpad support
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      scrollMethod = "twofinger";
    };
  };

  # User account and configuration
  users.users.loren = {
    isNormalUser = true;
    home = "/home/loren";
    createHome = true;
    extraGroups = [ "wheel"
                    "audio"
                    "input"
                    "docker"
                    "networkmanager" 
                    "systemd-journal" 
                    "video"];
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
    # Terminal and CLI utilities
    zsh
    inputs.nix-inspect.packages.${pkgs.system}.default
    # Text editors and office
    emacs-git
    vim_configurable
    # Programming languages (here to avoid environment clashes)
    gfortran
    #  julia-bin
    mono
    qt6.full
    (let
      my-python-packages = python-packages: with python-packages; [
        # Language server protocol
        ruff-lsp
        # Scientific libraries
        ipython
        ipykernel
        jupyter
        matplotlib
        mpmath
        numpy
        pandas
        scikit-learn
        scipy
        sympy
        # Qt backend
        pyqt6
        # Documentation
        sphinx
        # Linters
        autopep8
        flake8
        jedi
        mypy
        pydocstyle
        pylint
        # Web
        tornado
        # Hy utilities
        hy
        # Dependencies
        pickleshare
      ];
      python-with-my-packages = python3.withPackages my-python-packages;
    in
      python-with-my-packages)
    (hy.withPackages (py-packages: with py-packages; [
      # Scientific libraries
      numpy
      matplotlib
      pandas
      scipy
      sympy
      # Qt backend
      pyqt6
    ]))
  ];

  # Emacs configuration
  services.emacs = {
    enable = true;
    package = pkgs.emacs-git;
    defaultEditor = true;
  };

  # Enable Java
  programs.java.enable = true;

  # Use Flatpak, just in case
  services.flatpak.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    bqn386
    dina-font
    fira-code
    fira-code-symbols
    font-awesome
    iosevka
    liberation_ttf
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    proggyfonts
    source-code-pro
    uiua386
    (nerdfonts.override { fonts = [ "FiraCode" "SourceCodePro" ]; })
  ];

  # Gnome apps configuration
  programs.dconf.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese
    gnome-music
  ]);

  # Gnupg configuration
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Virtualization setup, only docker at the moment
  virtualisation = {
    docker = {
      enable = true;
      extraOptions = "--default-ulimit nofile=65536:65536";
    };
  };

  # Additional services
  services.actkbd.enable = true;
  services.gvfs.enable = true;
  services.openssh.enable = true;
  services.upower.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
  };
  systemd.user.services.maestral = {
    enable = true;
    description = "Maestral";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.maestral-gui}/bin/maestral_qt";
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };

  # Wifi sevice fix for P16s
  systemd.services = {
    ath11k-fix = {
      enable = false;

      description = "Suspend fix for ath11k_pci";
      before = [ "sleep.target" ];

      unitConfig = {
        StopWhenUnneeded = "yes";
      };

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = "/run/current-system/sw/bin/modprobe -r ath11k_pci";
        ExecStop = "/run/current-system/sw/bin/modprobe ath11k_pci";
      };

      wantedBy = [ "sleep.target" ];
    };
  };

  # State version
  system.stateVersion = "24.05";
}
