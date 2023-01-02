with import <nixpkgs> {};

(let
  my_jedhy = pkgs.python3Packages.buildPythonPackage rec {
    version = "1";
    pname = "jedhy";

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "0964b4a159aef450bc4783faa0b37114eb3c9f2eaa69e4b1ed7856ed398d15ab";
    };

    doCheck = false;
    buildInputs = [
      pkgs.python3Packages.toolz
    ];

    #propagatedBuildInputs = [
    #  pkgs.python3Packages.json5
    #  pkgs.python3Packages.packaging
    #];

    meta = with lib; {
      homepage = "https://github.com/ekaschalk/jedhy";
      description = "IDE features for Hy editing.";
    };
  };

in pkgs.python3.buildEnv.override rec {
  extraLibs = [ my_jedhy ];
}
).env
