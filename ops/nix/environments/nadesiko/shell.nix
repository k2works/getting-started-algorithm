{ packages ? import <nixpkgs> {} }:
let
  baseShell = import ../../shells/shell.nix { inherit packages; };
  gonakoVersion = "3.8.8";
  gonakoCommit = "f840295acd3d1a81b4e846a0bd33dda1877af9da";
in
packages.mkShell {
  inherit (baseShell) pure;
  buildInputs = baseShell.buildInputs ++ (with packages; [
    go
    gnumake
  ]);
  shellHook = ''
    ${baseShell.shellHook}

    export GONAKO_VERSION="${gonakoVersion}"
    export GOBIN="$(pwd)/apps/nadesiko/bin"
    export PATH="$GOBIN:$PATH"
    export GOTOOLCHAIN=auto

    if [ ! -x "$GOBIN/gonako" ] && [ -d "$(pwd)/apps/nadesiko" ]; then
      echo "Installing gonako ${gonakoVersion} ..."
      go install "github.com/kujirahand/nadesiko3go/cmd/gonako@${gonakoCommit}"
    fi

    echo "Nadesiko3 development environment activated"
    echo "  - Go: $(go version)"
    echo "  - gonako: $(gonako version)"
  '';
}
