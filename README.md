# Nix Rails Template

Template repo for developing rails projects with nix and vscode. Includes support for Ruby LSP and RuboCop.

Dependencies:

- Nix
- vscode/vscodium
- vscode extensions:
    - arrterian.nix-env-selector
    - mkhl.direnv
    - shopify.ruby-lsp

Commands Available:

- `bundle-lock`
- `bundle-update`
- `bundix`

Gem Workflow:

`bundle add GEM --skip-install` -> `bundle-lock` -> `bundix`

Rails init:

`rails new . --name=APP_NAME --skip-bundle`
