{
  description = "Nix flake for developing rails projects in vscode";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    ruby-nix.url = "github:inscapist/ruby-nix";
    # a fork that supports platform dependant gem
    bundix = {
      url = "github:inscapist/bundix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bob-ruby = {
      url = "github:bobvanderlinden/nixpkgs-ruby";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ruby-nix,
      bundix,
      bob-ruby,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ bob-ruby.overlays.default ];
      };
      rubyNix = ruby-nix.lib pkgs;

      # TODO generate gemset.nix with bundix
      gemset = if builtins.pathExists ./gemset.nix then import ./gemset.nix else { };

      # If you want to override gem build config, see
      #   https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/ruby-modules/gem-config/default.nix
      gemConfig = { };

      # See available versions here: https://github.com/bobvanderlinden/nixpkgs-ruby/blob/master/ruby/versions.json
      ruby = pkgs."ruby-4.0.2";

      # Running bundix would regenerate `gemset.nix`
      bundixcli = bundix.packages.${system}.default;

      # Use these instead of the original `bundle <mutate>` commands
      bundleLock = pkgs.writeShellScriptBin "bundle-lock" ''
        export BUNDLE_PATH=vendor/bundle
        bundle lock
      '';
      bundleUpdate = pkgs.writeShellScriptBin "bundle-update" ''
        export BUNDLE_PATH=vendor/bundle
        bundle lock --update
      '';
    in
    rec {
      inherit
        (rubyNix {
          inherit gemset ruby;
          name = "my-rails-app";
          gemConfig = pkgs.defaultGemConfig // gemConfig;
        })
        env
        ;

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          env
          bundixcli
          bundleLock
          bundleUpdate
        ]
        ++ (with pkgs; [
          yarn
          rufo
          sqlite
        ]);
      };

      ### Commands Available
      # bundle-lock
      # bundle-update
      # bundix

    };
}
