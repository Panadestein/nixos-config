{
  description = "Build papis-zotero";
  nixConfig.bash-prompt = ''\[\033[1;31m\][\[\033[0m\]\[\033[1;37m\]dev .\[\033[0m\]\[\033[1;34m\] $(basename \$$PWD)\[\033[0m\]\[\033[1;31m\]]\[\033[0m\] '';

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      papis-zotero-custom = pkgs.python3Packages.buildPythonPackage rec {
        version = "0.1.2";
        pname = "papis-zotero";

        src = pkgs.fetchFromGitHub {
          owner = "papis";
          repo = "papis-zotero";
          rev = "20a50ebbcb115fdddcbc922b4535f5c6c9f0e7b0";
          sha256 = "0242mz5dvv2nj91lsc81779y8ad1xs698crgv654wws96ll8knn9";
        };

        doCheck = false;
        propagatedBuildInputs = [
          pkgs.papis
          pkgs.python3Packages.papis
        ];

        meta = {
          homepage = "https://github.com/papis/papis-zotero";
          description = "Zotero support for papis";
        };
      };

    in
      {
        devShell.x86_64-linux = pkgs.mkShell {
          buildInputs = [
            papis-zotero-custom
          ];
        };
      };
}
