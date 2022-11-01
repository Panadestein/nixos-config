with import <nixpkgs> {};

(let
  my_rise = pkgs.python3Packages.buildPythonPackage rec {
    version = "5.7.1";
    pname = "rise";

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "641db777cb907bf5e6dc053098d7fd213813fa9a946542e52b900eb7095289a6";
    };

    doCheck = false;
    buildInputs = [
      pkgs.python3Packages.notebook
    ];
    propagatedBuildInputs = [
      pkgs.python3Packages.notebook
    ];

    meta = with lib; {
      homepage = "https://github.com/damianavila/RISE";
      description = "Reveal.js Jupyter";
    };
  };

in pkgs.python3.buildEnv.override rec {
  extraLibs = [ my_rise ];
}
).env
