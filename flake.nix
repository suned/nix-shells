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
      merge = pkgs.lib.lists.fold pkgs.lib.recursiveUpdate { };
      fmt = { formatter = pkgs.nixpkgs-fmt; };

      python310 = import ./python310.nix pkgs;
      python38 = import ./python38.nix pkgs;
      bunker-prices = {
        devShells.bunker-prices = python38.devShells.python38.overrideAttrs (final: prev: {
          nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.libffi pkgs-tf.terraform ];
        });
      };
      sbt191 = import ./sbt191.nix pkgs;
    in
    merge [ fmt python310 python38 sbt191 bunker-prices ]
  );
}
