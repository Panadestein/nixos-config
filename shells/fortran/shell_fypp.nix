with import <nixpkgs> {};

(let 
my_fypp = pkgs.python3Packages.buildPythonPackage rec {
  version = "3.1";
  pname = "fypp";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "b777ae70081c7c82edcf52eefc01a3e8a566b4e82ccd33ca3b2f06faf1d07d36";
  };

  meta = with lib; {
    homepage = "https://gnikit.github.io/fortls";
    description = "Python powered Fortran metaprogramming";
  };
};

in pkgs.python3.buildEnv.override rec {
  extraLibs = [ my_fypp pkgs.python3Packages.numpy ];
}
).env
