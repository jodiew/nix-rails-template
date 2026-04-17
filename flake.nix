{
  description = "Nix flake for developing ruby projects in vscode";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [
          ruby_4_0        # pin the interpreter
          ruby_4_0.devdoc # needed for `ri` to work
          libyaml         # for psych
          pkg-config
        ];

        # Redirect gem installs into the project dir
        shellHook = ''
          export GEM_HOME="$PWD/.gems"
          export PATH="$GEM_HOME/bin:$PATH"
          export BUNDLE_PATH="$PWD/.bundle"

          bundle install

          echo "[nix] Ruby $(ruby --version | cut -d' ' -f2) dev shell ready."
        '';
      };
    };
}
