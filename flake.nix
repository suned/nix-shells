{
  description = "dev shells for various environments";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};

      python310 = pkgs.mkShell {
        name = "python310";
        packages = [
          pkgs.python310
          pkgs.poetry
        ];
      };

      python38 = pkgs.mkShell {
        name = "python38";
        packages = [
          pkgs.python38
          pkgs.poetry
        ];
      };

      bunker-prices = pkgs.mkShell {
        name = "bunker-prices";
        packages = [
          pkgs.python38
          pkgs.poetry
          pkgs.libffi
          pkgs.terraform
        ];
      };

      sbt191 = pkgs.mkShell
        {
          name = "sbt191";
          packages = [
            pkgs.sbt
          ];
        };

      node20 = pkgs.mkShell {
        name = "node20";
        packages = [
          pkgs.nodejs_20
          pkgs.yarn
        ];
      };

      bunker-prices-client = pkgs.mkShell {
        name = "bunker-prices-client";
        packages = [
          pkgs.nodejs_20
          pkgs.yarn
          pkgs.jdk19
        ];
      };

      bunker-prices-algo = pkgs.mkShell
        {
          name = "bunker-prices-algo";
          packages = [
            pkgs.python310Full
            pkgs.poetry
            pkgs.ghostscript
          ];

          shellHook = ''
            export DYLD_LIBRARY_PATH=${nixpkgs.lib.makeLibraryPath [ pkgs.ghostscript ]}
          '';
        };
    in
    {
      formatter = pkgs.nixpkgs-fmt;
      devShells = {
        inherit python310 python38 bunker-prices sbt191 node20 bunker-prices-client bunker-prices-algo;
      };
    }
  );
}
