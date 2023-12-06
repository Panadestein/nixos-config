{
  description = "A development flake for GreenX. Usage `nix develop .#devShell.x86_64-linux`";
  nixConfig.bash-prompt = ''\[\033[1;31m\][\[\033[0m\]\[\033[1;37m\]dev .\[\033[0m\]\[\033[1;34m\] $(basename \$$PWD)\[\033[0m\]\[\033[1;31m\]]\[\033[0m\] '';

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      findent = pkgs.stdenv.mkDerivation rec {
        pname = "findent";
        version = "4.2.6";
        
        src = pkgs.fetchurl {
          url = "mirror://sourceforge/findent/${pname}-${version}.tar.gz";
          sha512 = "1d97005a6f414a1876dd2140922125b7e399fc7b03afaea0b2fe6dfd7eb6baeb3bf16d3ae7b259e3c9a613a889f2759393c1ed5f98e5bda8ee6ea3ddd5e713c0";
        };

        nativeBuildInputs = [ pkgs.gnumake pkgs.gcc ];
        buildInputs = [ pkgs.flex pkgs.bison ]; 

        configureFlags = [ "--prefix=${placeholder "out"}" ];
        
        meta = {
          homepage = "https://sourceforge.net/projects/findent/";
          description = "A Fortran indenter";
        };
      };

      zofu = pkgs.stdenv.mkDerivation {
        pname = "zofu";
        version = "1.1.1";

        src = pkgs.fetchFromGitHub {
          owner = "acroucher";
          repo = "zofu";
          rev = "96cf65829610c7812f212b42268081af356c8f52";
          sha256 = "1i9ylxy52x7gg95dvrdb72pb45l2rsnrlnsi504cvpyngfnnxd0n";
        };

        buildInputs = [ pkgs.cmake pkgs.gfortran ];

        configurePhase = ''
          mkdir build
          cd build
          cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$out ../
        '';

        buildPhase = ''
          make -j4
        '';

        installPhase = ''
          make install
        '';
        
        meta = {
          homepage = "https://github.com/acroucher/zofu";
          description = "A Fortran unit test framework.";
        };
      };

      pygreenx = pkgs.python3Packages.buildPythonPackage {
        pname = "pygreenx";
        version = "1.0";

        src = ./python;

        propagatedBuildInputs = with pkgs.python3Packages; [
          pytest
          setuptools
          numpy
        ];

        meta = {
          homepage = "https://github.com/nomad-coe/greenX";
          description = "Python utils for the GreenX library.";
        };
      };

      color-vgrind = pkgs.python3Packages.buildPythonPackage rec {
        pname = "colour-valgrind";
        version = "0.3.9";

        src = pkgs.python3.pkgs.fetchPypi {
          inherit pname version;
          sha256 = "34a7d92e3c82a63d80644a571d3df8e4d29dd7b14b263dee90307d5d6432619d";
        };

        propagatedBuildInputs = with pkgs.python3Packages; [
          pip
          wheel
          six
          regex
          colorama
          setuptools
        ];

        meta = {
          homepage = "http://github.com/StarlitGhost/colour-valgrind";
          description = "A colorful wrapper for Valgrind.";
        };
      };

      custom-python-env = pkgs.python3.withPackages (ps: [
        color-vgrind
        pygreenx
      ]);
    in
      {
        devShell.x86_64-linux = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Python packages
            custom-python-env
            # Additional libraries and utils
            cmake
            doxygen
            findent
            gmp
            hotspot
            hyperfine
            lapack-reference
            linuxKernel.packages.linux_zen.perf
            python310Packages.pytest
            valgrind
            zofu
          ];
          shellHook = ''
            alias val=colour-valgrind;
          '';
        };
      };
}
