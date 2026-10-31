{ packages ? import <nixpkgs> {} }:
let
  baseShell = import ../../shells/shell.nix { inherit packages; };
in
packages.mkShell {
  inherit (baseShell) pure;
  buildInputs = baseShell.buildInputs ++ (with packages; [
    jdk25
    gradle
  ]);
  shellHook = ''
    ${baseShell.shellHook}
    echo "Kotlin development environment activated"
    echo "  - JDK: $(javac -version 2>&1)"
    echo "  - Gradle: $(gradle --version | grep Gradle | head -n 1)"
  '';
}
