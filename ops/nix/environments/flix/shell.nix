{ packages ? import <nixpkgs> {} }:
let
  baseShell = import ../../shells/shell.nix { inherit packages; };
  flixVersion = "0.75.1";
  baseShellHook = builtins.replaceStrings [ "\r" ] [ "" ] baseShell.shellHook;
in
packages.mkShell {
  inherit (baseShell) pure;
  buildInputs = baseShell.buildInputs ++ (with packages; [
    jdk21
    gnumake
  ]);
  shellHook = ''
    ${baseShellHook}

    export FLIX_VERSION="${flixVersion}"
    export FLIX_PROJECT="$PWD/apps/flix"
    export FLIX_JAR="$FLIX_PROJECT/flix.jar"

    flix() {
      if [ ! -f "$FLIX_JAR" ]; then
        echo "Flix ${flixVersion} is not installed. See docs/operation/Flix開発環境セットアップ手順書.md." >&2
        return 1
      fi
      java -jar "$FLIX_JAR" "$@"
    }

    echo "Flix development environment activated"
    echo "  - JDK: $(javac -version 2>&1)"
    echo "  - Flix: ${flixVersion}"
  '';
}
