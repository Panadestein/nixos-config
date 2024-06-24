{
  description = "My Nix/NixOS configuration";

  inputs = {
    # The nixpkgs channels
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home-manager following the unstable channel
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The Emacs overlay
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    # The QChem flake. Contains several quantum chemistry packages
    qchem-overlay.url = "github:Nix-QChem/NixOS-QChem";

    # Ranger-like nix config inspector
    nix-inspect.url = "github:bluskript/nix-inspect";

    # The best bibliography manager ever
    papis.url = "github:papis/papis";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      # Nest stable channel into default unstable
      overlay-stable = final: prev: {
        nixpkgs-stable = import inputs.nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      # Systems and users (Bergman's reference here)
      persona = "loren";
      rechnerNixOS = "cyrus";
      rechnerNonNixOS = "atabey";
    in
      {
        nixosConfigurations = {
          ${rechnerNixOS} = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs; };
            modules = [
              ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
              ./systems/${rechnerNixOS}/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.users.${persona} = ./home/${rechnerNixOS}/home.nix;
              }
            ];
          };
        };

        homeConfigurations.${persona} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/${rechnerNonNixOS}/home.nix
          ];
        };

        packages.${system}.${persona} = self.homeConfigurations.${persona}.activationPackage;
      };
}
