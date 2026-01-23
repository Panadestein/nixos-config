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
    # Use a stable wireplumber
    (final: prev: {
      wireplumber = final.nixpkgs-stable.wireplumber;
    })
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
      auto-optimise-store = true;
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
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Load AMD CPU microcode and firmware
  hardware.cpu.amd.updateMicrocode = true;
  hardware.firmware = [ pkgs.linux-firmware ];

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
  programs.fish.enable = true;

  # Network configuration
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = lib.mkDefault false;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
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
  services.xserver.deviceSection = ''Option "TearFree" "true"'';

  # Display manager
  services.displayManager = {
    gdm = {
      enable = true;
      wayland = true;
    };
  };
  services.xserver.displayManager = {
    lightdm = {
      enable = false;
      greeters.enso = {
        enable = true;
      }; 
    };
  };
  services.displayManager.defaultSession = lib.mkForce "gnome";

  # Window managers
  services.xserver.windowManager = {
    xmonad = {
      enable = false;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
      ];
    };
    qtile = {
      enable = false;
      package = inputs."qtile-flake".packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
    stumpwm = {
      enable = false;
    };
  };
  
  # Desktop environment
  services.desktopManager.gnome.enable = true;
  xdg.portal.enable = lib.mkIf
    (!config.services.desktopManager.gnome.enable)
    true;
  xdg.portal.configPackages = lib.mkIf
    (!config.services.desktopManager.gnome.enable)
    [ pkgs.xdg-desktop-portal-gtk ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,bqn";
    options = "grp:switch";
  };

  # Printing support with CUPS
  services.printing = {
    enable = true;
    drivers = [
      pkgs.nixpkgs-stable.hplip
      pkgs.nixpkgs-stable.hplipWithPlugin
    ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  programs.system-config-printer.enable = true;

  # Scanners
  hardware.sane.enable = true;

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
    inputs.nix-inspect.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.papis.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Text editors and office
    emacs-git
    vim-full
    # Programming languages (here to avoid environment clashes)
    gfortran
    mono
    (let
      my-python-packages = python-packages: with python-packages; [
        # Language server protocol
        ruff
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

  # Wayland electron apps
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    COLORTERM = "truecolor";
    TERM = "xterm-256color";
  };

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
    dina-font
    fira-code
    fira-code-symbols
    font-awesome
    iosevka
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    proggyfonts
    source-code-pro
    uiua386
    nerd-fonts.fira-code
  ];

  # GPaste
  programs.gpaste.enable = true;

  # Gnome apps configuration
  programs.dconf.enable = true;

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

  # Audio service
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.maestral-gui}/bin/maestral_qt";
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
      Environment = [
        "QT_QPA_PLATFORM=xcb"
        "QT_QPA_PLATFORMTHEME=generic"
      ];
    };
  };

  # Nasty P16's bug (https://bugzilla.kernel.org/show_bug.cgi?id=214649)
  powerManagement = {
    enable = true;
    powerDownCommands = ''
      systemctl stop NetworkManager.service
      sleep 1
      ${pkgs.kmod}/bin/modprobe -r ath11k_pci || true
    '';
    resumeCommands = ''
      ${pkgs.kmod}/bin/modprobe ath11k_pci
      systemctl start NetworkManager.service
    '';
  };

  # State version
  system.stateVersion = "24.05";
}
