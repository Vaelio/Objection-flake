{
  description = "Flake: Objection";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=25.11";
  };

  outputs = { self, nixpkgs }: 
  
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    python = pkgs.python312;
    semver = python.pkgs.buildPythonPackage rec {
      pname = "semver";
      version = "2.13.0"; # use your needed version

      src = pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-+g/ici7hw/V+rEeIIMOlri9iSvgmTL35AAyYD/f3Xj8=";
      };

      pyproject = true;
      build-system = [ python.pkgs.setuptools ];
      doCheck = false;
    };
    fridaToolsLib = pkgs.python312.pkgs.toPythonModule (pkgs.frida-tools.override {python3Packages = pkgs.python312Packages;});
    litecliLib = pkgs.python312.pkgs.toPythonModule (pkgs.litecli.override {python3Packages = pkgs.python312Packages;});
    deps = with pkgs; [
      click
      semver
      fridaToolsLib
      litecliLib
      python312Packages.packaging
      python312Packages.wheel
      python312Packages.setuptools
      python312Packages.tabulate
      python312Packages.requests
      python312Packages.flask
      python312Packages.pygments
      python312Packages.delegator-py
      python312Packages.setuptools
      python312Packages.frida-python
      python312Packages.prompt-toolkit
    ];
  in
  {

    packages.${system}.default = python.pkgs.buildPythonPackage rec {
      pname = "objection";
      version = "1.12.3";

      # Use PyPI source directly
      src = pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-Qwkn7LPfW/k3G4yLcuX9I1/3bZQf7tdrWFaRZycjNLQ=";
      };

      pyproject = true;
      build-system = [ python.pkgs.setuptools python.pkgs.wheel ];
      propagatedBuildInputs = deps;
      nativeBuildInputs = deps;
      doCheck = false; # disable tests to keep it simple
    };

  };
}

