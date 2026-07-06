{
  description = "A basic Elm project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default =
          let
            npmDeps = import ./npmDeps.nix;
          in
          pkgs.buildNpmPackage {
            name = "frontend";
            src = ./.;

            npmBuildScript = "build";

            inherit (npmDeps) npmDepsHash;

            doCheck = true;

            nativeBuildInputs = [
              pkgs.elmPackages.elm
              pkgs.elmPackages.elm-test
            ];

            configurePhase =
              let
                elmConfigure =
                  pkgs.elmPackages.fetchElmDeps {
                    elmPackages = import ./elm-srcs.nix;
                    elmVersion = "0.19.1";
                    registryDat = ./registry.dat;
                  };
              in
              ''
                ${elmConfigure}
              '';

            checkPhase = ''
              elm-test
            '';

            installPhase = ''
              mkdir -p $out/dist
              mv dist/* $out/dist
            '';
          };

        devShells.default = pkgs.mkShell {
          name = "elm2nix-example";

          packages = with pkgs.elmPackages; [
            elm
            elm-test
            pkgs.elm2nix
            pkgs.nodejs_20
            pkgs.prefetch-npm-deps
          ];
        };
      }
    );
}
