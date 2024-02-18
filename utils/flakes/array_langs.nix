{
  description = "An array language flake.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { 
        system = "x86_64-linux"; 
        config = {
          allowUnfree = true; 
          dyalog.acceptLicense = true;
        };
      };
    in
      {
        devShell.x86_64-linux = pkgs.mkShell {
          buildInputs = with pkgs; [
            # APL
            dyalog
            apl386
            # BQN
            cbqn
            bqn386
            # Uiua
            uiua
            uiua386
          ];
        };
      };
}