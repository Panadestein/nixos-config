{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, makeWrapper
, jdk17
, python3
, gdb
, rr
, perf
, libGL
, xorg
}:

let
  mavenDeps = {
    pty4j = fetchurl {
      url = "https://repo1.maven.org/maven2/org/jetbrains/pty4j/pty4j/0.12.13/pty4j-0.12.13.jar";
      sha256 = "8cae0b647c734dcd3ed5974bb596518f351d752e335a60084fcebab5da108c0d";
    };
    purejavacomm = fetchurl {
      url = "https://packages.jetbrains.team/maven/p/ij/intellij-dependencies/org/jetbrains/pty4j/purejavacomm/0.0.11.1/purejavacomm-0.0.11.1.jar";
      sha256 = "31c048a86057e07272429aa26e90713edbde96af9747362f27470d8e86a398a3";
    };
    jna = fetchurl {
      url = "https://repo1.maven.org/maven2/net/java/dev/jna/jna/5.12.1/jna-5.12.1.jar";
      sha256 = "91a814ac4f40d60dee91d842e1a8ad874c62197984403d0e3c30d39e55cf53b3";
    };
    jna_jpms = fetchurl {
      url = "https://repo1.maven.org/maven2/net/java/dev/jna/jna/5.12.1/jna-5.12.1-jpms.jar";
      sha256 = "033e8ac7a742624748bf251648f15096cf6e15abe0c4c15f4a77ca10816a1324";
    };
  };

  uiDeps = {
    types = fetchurl {
      url = "https://repo1.maven.org/maven2/io/github/humbleui/types/0.2.0/types-0.2.0.jar";
      sha256 = "38d94d00770c4f261ffb50ee68d5da853c416c8fe7c57842f0e28049fc26cca8";
    };
    skija_shared = fetchurl {
      url = "https://repo1.maven.org/maven2/io/github/humbleui/skija-shared/0.116.1/skija-shared-0.116.1.jar";
      sha256 = "27d1575798ab1c8c27f9e9ea8f2b179c2b606dae0ebf136c83b0fbb584ab6da0";
    };
    skija_linux_x64 = fetchurl {
      url = "https://repo1.maven.org/maven2/io/github/humbleui/skija-linux-x64/0.116.1/skija-linux-x64-0.116.1.jar";
      sha256 = "7c3ab50102ca2b4816954eaeb148fe62458646b2ac6c6611150658f6f8ff5f4b";
    };
    jwm = fetchurl {
      url = "https://repo1.maven.org/maven2/io/github/humbleui/jwm/0.4.13/jwm-0.4.13.jar";
      sha256 = "acc22fbb6b2259f26f74a94e5fff17196348a893187d3a4bea9a425f58690596";
    };
    lwjgl_core = fetchurl {
      url = "https://repo1.maven.org/maven2/org/lwjgl/lwjgl/3.3.0/lwjgl-3.3.0.jar";
      sha256 = "d04bb83798305ffb8322a60ae99c9f93493c7476abf780a1fde61c27e951dd07";
    };
    lwjgl_core_natives_linux = fetchurl {
      url = "https://repo1.maven.org/maven2/org/lwjgl/lwjgl/3.3.0/lwjgl-3.3.0-natives-linux.jar";
      sha256 = "ddab8a8ad1e982ef061fe49845bc9010a5b0af3cd563819b8698927e08405f91";
    };
    lwjgl_nfd = fetchurl {
      url = "https://repo1.maven.org/maven2/org/lwjgl/lwjgl-nfd/3.3.0/lwjgl-nfd-3.3.0.jar";
      sha256 = "64b66ab4e63ca40612c23cab4b4c73be8676396ab1bc7617b364f93703ba3f61";
    };
    lwjgl_nfd_natives_linux = fetchurl {
      url = "https://repo1.maven.org/maven2/org/lwjgl/lwjgl-nfd/3.3.0/lwjgl-nfd-3.3.0-natives-linux.jar";
      sha256 = "c40cb912c805f35c8a61170d49d22d255b986689f256a8e1e0757b5c484ec8a0";
    };
  };

  runtimeLibs = [
    libGL
    xorg.libX11
    xorg.libXrandr
    xorg.libXext
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXxf86vm
  ];

  runtimeDeps = [
    gdb
    rr
    perf
  ];

in
stdenv.mkDerivation rec {
  pname = "grr";
  version = "unstable-2024-11-26";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo  = "grr";
    rev   = "59863b3e536915a640783ce1898de3367ceeacc0";
    hash  = "sha256-dnrHPKozrJvPhBT1z8E8XTWMimJWIbzJ7ikmI+tHWNU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    jdk17
    python3
    makeWrapper
  ];

  # Symlink UIClone to UI if UI doesn't exist (fixing module layout)
  patchPhase = ''
    if [ -d UIClone ] && [ ! -e UI ]; then
      ln -s UIClone UI
    fi
  '';

  # Manually inject the Maven dependencies
  preBuild = ''
    mkdir -p lib
    mkdir -p UI/lib UI/lib/lwjgl-3.3.0

    cp ${mavenDeps.pty4j}        lib/pty4j-0.12.13.jar
    cp ${mavenDeps.purejavacomm} lib/purejavacomm-0.0.11.1.jar
    cp ${mavenDeps.jna}          lib/jna-5.12.1.jar
    cp ${mavenDeps.jna_jpms}     lib/jna-5.12.1-jpms.jar
    cp ${uiDeps.types}             UI/lib/types-0.2.0.jar
    cp ${uiDeps.skija_shared}      UI/lib/skija-shared-0.116.1.jar
    cp ${uiDeps.skija_linux_x64}   UI/lib/skija-linux-x64-0.116.1.jar
    cp ${uiDeps.jwm}               UI/lib/jwm-0.4.13.jar
    cp ${uiDeps.lwjgl_core}             UI/lib/lwjgl-3.3.0/lwjgl-3.3.0.jar
    cp ${uiDeps.lwjgl_core_natives_linux} UI/lib/lwjgl-3.3.0/lwjgl-3.3.0-natives-linux.jar
    cp ${uiDeps.lwjgl_nfd}              UI/lib/lwjgl-3.3.0/lwjgl-nfd-3.3.0.jar
    cp ${uiDeps.lwjgl_nfd_natives_linux} UI/lib/lwjgl-3.3.0/lwjgl-nfd-3.3.0-natives-linux.jar
  '';

  buildPhase = ''
    runHook preBuild
    python3 build.py
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/java/grr
    mkdir -p $out/share/applications

    # Artifacts produced by build.py (grr.jar, lib/, res/)
    cp grr.jar $out/share/java/grr/
    cp -r lib  $out/share/java/grr/
    cp -r res  $out/share/java/grr/
    if [ -d UI/lib ]; then
      cp -r UI/lib/* $out/share/java/grr/lib/
    fi

    # Wrapper script
    makeWrapper ${jdk17}/bin/java $out/bin/grr \
      --add-flags "-DRES_DIR=$out/share/java/grr/res -ea -cp $out/share/java/grr/grr.jar:$out/share/java/grr/lib/* dz.Main" \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath runtimeLibs} \
      --set _JAVA_AWT_WM_NONREPARENTING 1

    # Desktop entry for rofi
    cat > $out/share/applications/grr.desktop <<EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=grr
Comment=A GUI for gdb, rr, perf, and more
Exec=grr
Terminal=false
Categories=Development;Debugger;
EOF

    runHook postInstall
  '';

  meta = with lib; {
    description = "A GUI for gdb, rr, perf, and more";
    homepage    = "https://github.com/dzaima/grr";
    license     = licenses.mit;
    platforms   = [ "x86_64-linux" ];
    mainProgram = "grr";
  };
}
