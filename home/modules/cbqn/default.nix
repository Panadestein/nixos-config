{ config, lib, clangStdenv, pkg-config, libffi, fetchFromGitHub }:
let
  version = "rolling";
  cbqnSrc = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "26325ca2d3846137a2c634892126b27221e6687f";
    hash = "sha256-SG4txcdUb0AtLGsD3xYWo9BAAD1C1cutfllIvYdUnKc=";
    fetchSubmodules = true;
  };
in clangStdenv.mkDerivation {
  pname = "cbqn";
  version = version;
  src = cbqnSrc;

  nativeBuildInputs = [ pkg-config ];
  buildInputs       = [ libffi ];

  # Set the system C compiler to Clang
  makeFlags = [ "CC=${clangStdenv.cc.targetPrefix}cc" ];

  # Customize build for maximum performance on Zen 4.
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
