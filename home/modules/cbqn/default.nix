{
  lib,
  pkgs,
  pkg-config,
  libffi,
  src,
}:

let
  nativeStdenv = pkgs.impureUseNativeOptimizations pkgs.stdenv;
in
nativeStdenv.mkDerivation {
  pname = "cbqn";
  version = "develop";
  inherit src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libffi ];

  makeFlags = [
    "CC=${nativeStdenv.cc.targetPrefix}cc"
    "CXX=${nativeStdenv.cc.targetPrefix}c++"
  ];
  buildFlags = [
    "o3n"
    "notui=1"
    "target_from_cc=1"
    "nogit=1"
  ];

  dontConfigure = true;

  preBuild = ''
    cp -r build/singeliSubmodule build/singeliLocal
    cp -r build/replxxSubmodule build/replxxLocal
    cp -r build/bytecodeSubmodule build/bytecodeLocal
  '';

  postPatch = ''
    # Nix provides the build shell; the upstream hard-coded path is absent in
    # the sandbox. The build launcher needs a Nix-store shebang as well.
    sed -i '/SHELL =/d' makefile build/makefile
    patchShebangs build/build
  '';

  installPhase = ''
    runHook preInstall

    make install PREFIX="$out"
    ln -s bqn "$out/bin/cbqn"

    runHook postInstall
  '';

  meta = {
    description = "Native-optimized CBQN";
    homepage = "https://github.com/dzaima/CBQN";
    license = [
      lib.licenses.lgpl3Only
      lib.licenses.mit
      lib.licenses.asl20
    ];
    mainProgram = "cbqn";
    platforms = lib.platforms.linux;
  };
}
