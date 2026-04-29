# Nix Rails Template

Template repo for developing rails projects with nix and vscode. Includes support for Ruby LSP and RuboCop.

Dependencies:

- Nix
- vscode/vscodium
- vscode extensions:
    - arrterian.nix-env-selector
    - mkhl.direnv
    - shopify.ruby-lsp

Rails init:

`rails new . --name=APP_NAME --database=postgresql`

PostgreSQL commands:

`pg_ctl -D tmp/mydb stop`

`createdb <linux_username> --host="$PWD/tmp"`

update `config/database.yaml` to have `host: PWD/tmp`
