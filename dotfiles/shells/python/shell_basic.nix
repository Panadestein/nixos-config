# Simple nix-shell for data processing in Python
{ pkgs ? import <nixpkgs> {} }:
let
  python-with-my-packages = pkgs.python3.withPackages (p: with p; [
    numpy
    matplotlib
    pyqt5
    scikit-learn
    mpmath
  ]);
in
python-with-my-packages.env
