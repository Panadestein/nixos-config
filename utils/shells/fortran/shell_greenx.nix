{ pkgs ? import <nixpkgs> {} }:
let
  python-with-my-packages = with pkgs.python3Packages;
    buildPythonPackage rec {
      name = "GreenX";
      src = ./greenX_ref/python;
      propagatedBuildInputs = [ pytest
                                numpy
                                matplotlib
                                pandas
                                pyqt5
                              ];
    };
in
pkgs.mkShell {
  packages = [
    python-with-my-packages
    pkgs.python310Packages.pytest
    pkgs.doxygen
    pkgs.lapack-reference
    pkgs.cmake
    pkgs.valgrind
    pkgs.linuxKernel.packages.linux_6_0.perf
  ];
}

