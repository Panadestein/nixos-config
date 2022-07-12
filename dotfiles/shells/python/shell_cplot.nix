# Example of a more elaborated shell.nix
# It installs the cplot python package, which is not in the nixpkgs,
# and so are not two of its dependencies.

with import <nixpkgs> {};

( let
  my_matplotx = pkgs.python3Packages.buildPythonPackage rec {
    format = "pyproject";
    pname = "matplotx";
    version = "0.3.7";

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "a003f9a2e463720ced8062fac543d0087c6c2beedc75072679841c68bd8471a6";
    };

    doCheck = false;
    buildInputs = [ pkgs.python3Packages.flit-core
                    pkgs.python3Packages.scipy
                    pkgs.python3Packages.pypng
                    pkgs.python3Packages.networkx
                    pkgs.python3Packages.matplotlib ];
    propagatedBuildInputs = [ pkgs.python3Packages.matplotlib
                              pkgs.python3Packages.pypng
                              pkgs.python3Packages.networkx
                              pkgs.python3Packages.scipy ];

    meta = with lib; {
      homepage = "https://github.com/nschloe/matplotx";
      description = "Improved Matplotlib library";
    };
  };

  my_npx = pkgs.python3Packages.buildPythonPackage rec {
    format = "pyproject";
    pname = "npx";
    version = "0.1.1";

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "cce26aad91af079a721750a5bdcb5ca7435bf2feef4642afcf580d58cb151bd4";
    };

    doCheck = false;
    buildInputs = [ pkgs.python3Packages.flit-core pkgs.python3Packages.numpy ];
    propagatedBuildInputs = [ pkgs.python3Packages.numpy ];

    meta = with lib; {
      homepage = "https://github.com/nschloe/npx";
      description = "Improved Numpy library";
    };
  };
  
  my_cplot = pkgs.python3Packages.buildPythonPackage rec {
    format = "pyproject";
    pname = "cplot";
    version = "0.9.1";

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "c34611d13bf009641b96193f8db1f671d5bd4e4238ace3ad4ba752697b09a631";
    };

    buildInputs = [ pkgs.python3Packages.flit-core
                    my_npx
                    my_matplotx ];
    doCheck = true;

    meta = with lib; {
      homepage = "https://github.com/nschloe/cplot";
      description = "Plot complex functions with style";
    };
  };

in pkgs.python3.buildEnv.override rec {
  extraLibs = [ pkgs.python3Packages.numpy pkgs.python3Packages.pyqt5 my_cplot my_npx my_matplotx ];
}

).env
