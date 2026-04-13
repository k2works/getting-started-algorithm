{ packages ? import <nixpkgs> {} }:
let
  baseShell = import ../../shells/shell.nix { inherit packages; };
in
packages.mkShell {
  inherit (baseShell) pure;
  buildInputs = baseShell.buildInputs ++ (with packages; [
    gcc
    gnumake
    clang-tools
    valgrind
  ]);
  shellHook = ''
    ${baseShell.shellHook}
    echo "C development environment activated"
    echo "  - GCC: $(gcc --version | head -n 1)"
    echo "  - Make: $(make --version | head -n 1)"
  '';
}
