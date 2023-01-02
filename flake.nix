{
  description = "My Nix/NixOS configuration";

  inputs = {
    # The unstable nixpkgs channel
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home-manager following the unstable channel
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The Emacs overlay
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      # Systems and users
      unixes = "loren";
      mnixos = "cyrus";
    in
      {
        nixosConfigurations = {
          ${mnixos} = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs; };
            modules = [
              ./configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.users.${unixes} = ./home.nix;
              }
            ];
          };
        };

        homeConfigurations.${unixes} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home.nix ];
        };

        packages.${system}.${unixes} = self.homeConfigurations.${unixes}.activationPackage;
      };
}
