{
  description = "dev shells for various environments";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  };

  outputs = { self, nixpkgs, flake-utils, nixpkgs-unstable }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { system = system; config.allowUnfree = true; };
      pkgs-unstable = import nixpkgs-unstable { system = system; config.allowUnfree = true; };

      python-devel = pkgs.mkShell {
        name = "python-devel";
        packages = [
          pkgs.pkg-config
          pkgs.openssl
          pkgs.xz
          pkgs.gdbm
          pkgs.tcl
          pkgs.mpdecimal
        ];
      };

      voyage-performance = pkgs.mkShell {
        name = "voyage-performance";
        packages = [
          pkgs-unstable.uv
          pkgs.go
          pkgs.pango
          pkgs.glib
          pkgs.harfbuzz
          pkgs.fontconfig
          pkgs.python311
          pkgs.postgresql
          pkgs.openssl
        ];

        shellHook = ''
          export DYLD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [ pkgs.glib pkgs.pango pkgs.harfbuzz pkgs.fontconfig ]}
          export FONTCONFIG_PATH=/System/Library/Fonts
        '';
      };

      zeronorth = pkgs.mkShell
        {
          name = "zeronorth";
          packages = [
            pkgs.terraform
            pkgs.copier
            pkgs.awscli2
          ];
        };

      datalake = pkgs.mkShell
        {
          name = "datalake";
          packages = [
            pkgs.poetry
            pkgs.gdal
            pkgs.geos
            pkgs.pipx
          ];
          shellHook = ''
            export GDAL_LIBRARY_PATH=${pkgs.gdal}/lib/libgdal.dylib
            export GEOS_LIBRARY_PATH=${pkgs.geos}/lib/libgeos_c.1.dylib
          '';
        };

      python312 = pkgs.mkShell {
        name = "python312";
        packages = [
          pkgs.python312
          pkgs.poetry
        ];
      };

      python313 = pkgs.mkShell {
        name = "python313";
        packages = [
          pkgs.python313
          pkgs.poetry
        ];
      };

      python310 = pkgs.mkShell {
        name = "python310";
        packages = [
          pkgs.python310
          pkgs.poetry
        ];
      };

      bunker-prices = pkgs.mkShell {
        name = "bunker-prices";
        packages = [
          pkgs.python311
          pkgs.poetry
          pkgs.libffi
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
        inherit python312 python310 bunker-prices sbt191 node20 bunker-prices-algo zeronorth python313 datalake python-devel voyage-performance;
      };
    }
  );
}
