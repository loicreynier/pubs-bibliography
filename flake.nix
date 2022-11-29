{
  description = "pubs bibliography";

  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    pre-commit-hooks,
  }: let
    supportedSystems = ["x86_64-linux"];
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in rec {
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = with pkgs; {
            make_bib = {
              enable = true;
              name = "make-bibliography";
              entry = "${pkgs.stdenv.shell} ./docs/make-bib.sh";
              files = "yaml";
              language = "system";
              pass_filenames = false;
            };
            make_readme = {
              enable = true;
              name = "make-readme";
              entry = "${pkgs.stdenv.shell} ./docs/make-readme.sh";
              files = "yaml";
              language = "system";
              pass_filenames = false;
            };
            alejandra.enable = true;
            commitizen = {
              enable = true;
              entry = "${pkgs.commitizen}/bin/cz check --commit-msg-file";
              stages = ["commit-msg"];
            };
            editorconfig-checker = {
              enable = true;
              entry = "${pkgs.editorconfig-checker}/bin/editorconfig-checker";
              types = ["file"];
            };
            prettier = {
              enable = true;
              excludes = ["README\\.md"];
            };
            statix.enable = true;
          };
        };
      };

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          pubs
          just
          pandoc
        ];
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    });
}
