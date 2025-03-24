{ config, lib, stdenv, pkg-config, libffi, fetchFromGitHub }:
let
  version = "rolling";
  cbqnSrc = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "09642a354f124630996a6ae4e8442089625cd907";
    hash = "sha256-jLi9uqBWGVJlhwHWDvfyd2EI3ldvjfXK9ZVCj2c0LsI=";
  };

  cbqnBytecode = fetchFromGitHub {
    owner = "dzaima";
    repo = "cbqnBytecode";
    rev = "0bdfb86d438a970b983afbca93011ebd92152b88";
    hash = "sha256-oUM4UwLy9tusTFLlaZbbHfFqKEcqd9Mh4tTqiyvMyvo=";
  };

  replxx = fetchFromGitHub {
    owner = "dzaima";
    repo = "replxx";
    rev = "13f7b60f4f79c2f14f352a76d94860bad0fc7ce9";
    hash = "sha256-xPuQ5YBDSqhZCwssbaN/FcTZlc3ampYl7nfl2bbsgBA=";
  };

  singeli = fetchFromGitHub {
    owner = "mlochbaum";
    repo = "Singeli";
    rev = "60951d9615d7545c0f9da7a3e082900517e4a208";
    hash = "sha256-eRwtDrcTeAEdX5KuMyGSroPdHMxDaG1nucNOja6w1pc=";
  };
in stdenv.mkDerivation {
  pname = "cbqn";
  version = version;
  src = cbqnSrc;

  nativeBuildInputs = [ pkg-config ];
  buildInputs       = [ libffi ];

  # Pass the system C compiler appropriately.
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  # Use o3n for a native build, disable fancy UI output, enable REPLXX,
  # and enforce AVX2 optimizations for your machine.
  buildFlags = [
    "o3"
    "notui=1"
    "REPLXX=1"
    "f=-march=znver4"
    "target_from_cc=1"
  ];

  dontConfigure = true;

  preBuild = ''
    # Set up local copies of required submodules.
    mkdir -p build/singeliLocal
    cp -r ${singeli}/. build/singeliLocal/
    mkdir -p build/bytecodeLocal/gen
    cp -r ${cbqnBytecode}/. build/bytecodeLocal/
    mkdir -p build/replxxLocal
    cp -r ${replxx}/. build/replxxLocal/
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
