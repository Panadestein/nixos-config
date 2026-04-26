{ config, lib, clangStdenv, pkg-config, libffi, fetchFromGitHub }:
let
  version = "rolling";
  cbqnSrc = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "d56147be877693eaed351745782c258bd7424de7";
    hash = "sha256-6VOTwoxIBko8z8jKWQlF3GOc4noR+I2taa3CGJOEFqI=";
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
