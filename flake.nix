{
  description = "dev shells for various environments";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-tf.url = "github:nixos/nixpkgs?rev=80c24eeb9ff46aa99617844d0c4168659e35175f";
  };

  outputs = { self, nixpkgs, flake-utils, nixpkgs-tf }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-tf = nixpkgs-tf.legacyPackages.${system};

      python310 = pkgs.mkShell {
        packages = [
          pkgs.python310
          pkgs.poetry
        ];
      };

      python38 = pkgs.mkShell {
        packages = [
          pkgs.python38
          pkgs.poetry
        ];
      };

      bunker-prices = pkgs.mkShell {
        packages = [
          pkgs.python38
          pkgs.poetry
          pkgs.libffi
          pkgs-tf.terraform
        ];
      };

      sbt191 = pkgs.mkShell
        {
          packages = [
            pkgs.sbt
          ];
        };
    in
    {
      formatter = pkgs.nixpkgs-fmt;
      devShells = {
        inherit python310 python38 bunker-prices sbt191;
      };
    }
  );
}
