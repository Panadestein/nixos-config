{
  description = "My Nix/NixOS configuration";

  inputs = {
    # The nixpkgs channels
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home-manager following the unstable channel
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Determinate Nix and its daemon for NixOS.
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    # CBQN's development branch, pinned by flake.lock.
    cbqn = {
      url = "git+https://github.com/dzaima/CBQN?ref=develop&submodules=1";
      flake = false;
    };

    # The Emacs overlay
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    # Personal Emacs configuration, pinned by flake.lock.
    emacs-config = {
      url = "github:Panadestein/emacsd";
      flake = false;
    };

    # LLM agents
    llm-agents.url = "github:numtide/llm-agents.nix";

    # Ranger-like nix config inspector
    nix-inspect.url = "github:bluskript/nix-inspect";

    # The best bibliography manager ever
    papis.url = "github:papis/papis";

    # Retro terminal music player
    cliamp = {
      url = "github:bjarneo/cliamp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative disk partitioning and formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      scientificPython = pkgs.python3.withPackages (
        pythonPackages: with pythonPackages; [
          ipykernel
          ipython
          jupyterlab
          matplotlib
          numpy
          pandas
          pyqt6
          scikit-learn
          scipy
        ]
      );
      # System and user (Bergman's reference here)
      persona = "loren";
      rechnerNixOS = "cyrus";
    in
    {
      nixosConfigurations = {
        ${rechnerNixOS} = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            {
              nix.registry.llm-agents.flake = inputs.llm-agents;
            }
            inputs.determinate.nixosModules.default
            ./systems/${rechnerNixOS}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs; };
                users.${persona} = ./home/${rechnerNixOS}/home.nix;
              };
            }
          ];
        };
      };

      devShells.${system} = {
        default = pkgs.mkShellNoCC {
          name = "nixos-config";
          packages = with pkgs; [
            deadnix
            nixfmt
            statix
          ];
        };

        python = pkgs.mkShellNoCC {
          name = "scientific-python";
          packages = [ scientificPython ];
        };

        c-cpp = pkgs.mkShell {
          name = "c-cpp";
          packages = with pkgs; [
            clang-tools
            cmake
            gcc
            gdb
            ninja
            pkg-config
            valgrind
          ];
        };

        fortran-mpi = pkgs.mkShell {
          name = "fortran-mpi";
          packages = with pkgs; [
            cmake
            fortls
            fypp
            gfortran
            ninja
            openmpi
            pkg-config
          ];
        };

        julia = pkgs.mkShellNoCC {
          name = "julia";
          packages = [ pkgs.julia-bin ];
        };
      };
    };
}
