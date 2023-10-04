{
  description = "An qiskit development flake";
  nixConfig.bash-prompt = ''\[\033[1;31m\][\[\033[0m\]\[\033[1;37m\]dev .\[\033[0m\]\[\033[1;34m\] $(basename \$$PWD)\[\033[0m\]\[\033[1;31m\]]\[\033[0m\] '';

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      my_qiskit_terra = pkgs.python3Packages.buildPythonPackage rec {
        version = "0.25.2";
        pname = "qiskit-terra";

        src = pkgs.python3.pkgs.fetchPypi {
          inherit pname version;
          sha256 = "b865af9696a71aeca17c2e926c262a9160191aa247c98c3d75860d3ff34bdc67";
        };

        doCheck = false;

        nativeBuildInputs = [
          pkgs.cargo
          pkgs.rustc
          pkgs.rustPlatform.cargoSetupHook
          pkgs.python3Packages.setuptools-rust
        ];

        propagatedBuildInputs = [
          pkgs.symengine
          pkgs.python3Packages.dill
          pkgs.python3Packages.numpy
          pkgs.python3Packages.networkx
          pkgs.python3Packages.ply
          pkgs.python3Packages.psutil
          pkgs.python3Packages.python-constraint
          pkgs.python3Packages.python-dateutil
          pkgs.python3Packages.rustworkx
          pkgs.python3Packages.scipy
          pkgs.python3Packages.stevedore
          pkgs.python3Packages.sympy
          pkgs.python3Packages.tweedledum
        ];
        
        cargoDeps = pkgs.rustPlatform.fetchCargoTarball {
          inherit src;
          name = "${pname}-${version}";
          hash = "sha256-Ex/L3L21wUcV69/hDrhbG0LcVyggQdCSU5EwJatphPA=";
        };

        meta = with pkgs.lib; {
          homepage = "https://qiskit.org/";
          description = "Software for developing quantum computing programs";
        };
      };

      my_qiskit = pkgs.python3Packages.buildPythonPackage rec {
        version = "0.44.1";
        pname = "qiskit";

        src = pkgs.python3.pkgs.fetchPypi {
          inherit pname version;
          sha256 = "353c1aa2624c4044bd7013bd1e996a736c60934ebe323119c1f5b07527c6b05f";
        };

        doCheck = false;
        propagatedBuildInputs = [
          my_qiskit_terra
          pkgs.python3Packages.typing-extensions
        ];

        meta = with pkgs.lib; {
          homepage = "https://qiskit.org/";
          description = "Open-source toolkit for useful quantum computing";
        };
      };

      my_python_env = pkgs.python3.withPackages (ps: [
        ps.numpy
        ps.scipy
        ps.matplotlib
        my_qiskit
      ]);

    in
      {
        devShell.x86_64-linux = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Python packages
            my_python_env
          ];
        };
      };
}
