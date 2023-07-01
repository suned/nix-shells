pkgs: {
  devShells.python310 = pkgs.mkShell {
    buildInputs = [
      pkgs.python310
      pkgs.poetry
    ];
  };
}
