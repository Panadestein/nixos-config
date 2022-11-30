{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    cmake
    lapack-reference
    doxygen
    python310Packages.pytest
  ];
}
