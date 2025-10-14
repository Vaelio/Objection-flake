{
  description = "Flake: Objection";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=25.05";
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
    deps = with pkgs; [
      frida-tools
      click
      litecli
      semver
      python312Packages.tabulate
      python312Packages.requests
      python312Packages.flask
      python312Packages.pygments
      python312Packages.delegator-py
      python312Packages.setuptools
    ];
  in
  {

    packages.${system}.default = python.pkgs.buildPythonPackage rec {
      pname = "objection";
      version = "1.11.0";

      # Use PyPI source directly
      src = pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-HhZ+FXlyC2ijvMMM9F5iv5i6OUIwfMTN9OQgHzkguHo=";
      };

      pyproject = true;
      build-system = [ python.pkgs.setuptools ];
      propagatedBuildInputs = deps;
      nativeBuildInputs = deps;
      doCheck = false; # disable tests to keep it simple
    };

  };
}

