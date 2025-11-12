{ config, lib, stdenv, pkg-config, libffi, fetchFromGitHub }:
let
  version = "rolling";
  cbqnSrc = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "3f3e81d8073fa8b736947e2dde36ffb62f613821";
    hash = "sha256-Kbr/9SGYk7Fz2bB5DlULo0EUU2LWwFMvPvU7eOZZDXg=";
    fetchSubmodules = true;
  };
in stdenv.mkDerivation {
  pname = "cbqn";
  version = version;
  src = cbqnSrc;

  nativeBuildInputs = [ pkg-config ];
  buildInputs       = [ libffi ];

  # Set the system C compiler
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  # Customize build for maximum performance.
  buildFlags = [
    "o3"
    "notui=1"
    "REPLXX=1"
    "f=-march=znver4"
    "target_from_cc=1"
  ];

  dontConfigure = true;

  # Set up local copies of required submodules.
  preBuild = ''
    mkdir -p build/{singeliLocal,bytecodeLocal,replxxLocal}
    cp -r build/singeliSubmodule/* build/singeliLocal/
    cp -r build/bytecodeSubmodule/* build/bytecodeLocal/
    cp -r build/replxxSubmodule/* build/replxxLocal/
  '';

  postPatch = ''
    # Remove the SHELL definition from the makefile and fix shebangs.
    sed -i '/SHELL =/d' makefile
    patchShebangs build/build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp BQN $out/bin/
    ln -sf BQN $out/bin/bqn
    ln -sf BQN $out/bin/cbqn
  '';

  meta = with lib; {
    description = "Optimized CBQN interpreter with REPLXX support for AMD Ryzen";
    homepage    = "https://github.com/dzaima/CBQN";
    license     = licenses.gpl3Only;
    platforms   = platforms.linux;
  };
}
