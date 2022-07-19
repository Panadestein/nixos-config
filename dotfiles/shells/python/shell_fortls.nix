with import <nixpkgs> {};

(let 
my_fortls = pkgs.python3Packages.buildPythonPackage rec {
  version = "2.12.0";
  pname = "fortls";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "4c2755a0ada0fcc18519458fbac4f4bd7dacfd4edc70f785e95a3c7d93f59ab1";
  };

  doCheck = false;
  buildInputs = [
    pkgs.python3Packages.json5
    pkgs.python3Packages.packaging
    pkgs.python3Packages.importlib-metadata
    pkgs.python3Packages.typing-extensions
  ];
  propagatedBuildInputs = [
    pkgs.python3Packages.json5
    pkgs.python3Packages.packaging
  ];

  meta = with lib; {
    homepage = "https://gnikit.github.io/fortls";
    description = "Improved Fortran language server";
  };
};

in pkgs.python3.buildEnv.override rec {
  extraLibs = [ my_fortls ];
}
).env

