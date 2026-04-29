# flake.nix
{
  description = "Nix flake for developing rails projects in vscode";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [
          ruby_4_0 # pin the interpreter
          bundler
          nodejs_25 # for asset pipeline / esbuild
          postgresql_18 # for pg gem native ext
          libpq # headers for pg gem
          libyaml # for psych
          pkg-config
          gcc
        ];

        # Redirect gem installs into the project dir
        shellHook = ''
          export GEM_HOME="$PWD/.gems"
          export PATH="$GEM_HOME/bin:$PATH"
          export BUNDLE_PATH="$PWD/.bundle"

          ruby --version
          if ! gem list -i "^rails$"; then
            gem install rails ruby-lsp rubocop rubocop-ast rubocop-capybara rubocop-rails rubocop-rspec
          fi
          rails --version
          if [ ! -d tmp/mydb ]; then
            initdb -D tmp/mydb
          fi
          if ! pg_ctl -D tmp/mydb status; then
            pg_ctl -D tmp/mydb -l log/mydb_logfile -o "--unix_socket_directories='$PWD/tmp'" start
          fi
        '';
      };
    };
}
