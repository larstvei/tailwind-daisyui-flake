{
  description = "A flake for tailwindcss with daisyui bundled";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        tailwindcssNpm = pkgs.buildNpmPackage {
          name = "tailwindcss";
          dontNpmBuild = true;
          src = ./.;
          npmDepsHash = "sha256-9gAUt5s96Mv1wNIcKxJVLvGZP5HTPMJz8XRMt38uWHQ=";
        };

        tailwindcssBin = pkgs.writeShellScriptBin "tailwindcss" ''
          cd ${tailwindcssNpm}/lib/node_modules/tailwind-daisyui-flake
          exec ${pkgs.nodejs}/bin/npx tailwindcss "$@"
        '';
      in {
        packages.tailwindNpm = tailwindcssNpm;
        packages.default = tailwindcssBin;

        devShell = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.nodejs
            pkgs.prefetch-npm-deps
          ];
        };
      });
}
