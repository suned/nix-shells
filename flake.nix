{
  description = "dev shells for various environments";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      merge = pkgs.lib.lists.fold pkgs.lib.recursiveUpdate { };
      fmt = { formatter = pkgs.nixpkgs-fmt; };

      python310 = import ./python310.nix pkgs;
      sbt191 = import ./sbt191.nix pkgs;
    in
    merge [ fmt python310 sbt191 ]
  );
}
