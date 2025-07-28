{ config, lib, fetchFromGitHub, python313Packages, patchutils, ... }:

python313Packages.buildPythonPackage rec {
  pname = "dyalog-jupyter-kernel";
  version = "2.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner  = "Dyalog";
    repo   = "dyalog-jupyter-kernel";
    rev    = "master";
    sha256 = "0pc55if185c8hkgcl8f2jhz834r2p8nbk917qb0fd07f6psx4109";
  };

  nativeBuildInputs = with python313Packages; [
    setuptools
  ];
  propagatedBuildInputs = with python313Packages; [
    jupyter_client
    ipykernel
  ];

  doCheck  = false;

  meta = with lib; {
    description = "Dyalog APL Jupyter kernel";
    homepage    = "https://github.com/Dyalog/dyalog-jupyter-kernel";
    license     = licenses.mit;
  };
}
