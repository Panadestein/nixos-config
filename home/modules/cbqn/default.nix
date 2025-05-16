{ config, lib, stdenv, pkg-config, libffi, fetchFromGitHub }:
let
  version = "rolling";
  cbqnSrc = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "1ab511f657d8c32d7677e7bf18d46f0b25982d2e";
    hash = "sha256-p44H+3FmU93B7W1opZbGK8dN1gX/a0P8TGTYF8jSArU=";
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
