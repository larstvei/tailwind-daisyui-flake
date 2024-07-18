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
          npmDepsHash = "sha256-NTyMHdY6WjTvz38HtK7KCiK91OGiRNWC7ZSbRalfoG4=";
        };

        tailwindcssBin = pkgs.writeShellScriptBin "tailwindcss" ''
          export PATH=${pkgs.nodejs}/bin:$PATH
          npm run --prefix ${tailwindcssNpm}/lib/node_modules/tailwind-daisyui-flake tailwindcss -- "$(pwd)" "$@"
        '';
      in {
        packages.tailwindNpm = tailwindcssNpm;
        packages.default = tailwindcssBin;

        devShell = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.nodejs
            pkgs.prefetch-npm-deps
            tailwindcssBin
          ];
        };
      });
}
