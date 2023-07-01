pkgs: {
  devShells.sbt191 = pkgs.mkShell {
    buildInputs = [
      pkgs.sbt
    ];
  };
}
