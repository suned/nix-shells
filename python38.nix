pkgs: {
  devShells.python38 = pkgs.mkShell {
    packages = [
      pkgs.python38
      pkgs.poetry
    ];
  };
}
