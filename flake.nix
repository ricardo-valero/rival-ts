{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs = {nixpkgs, ...}: let
    systems = nixpkgs.lib.systems.flakeExposed;
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    formatter = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.alejandra
    );
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nixd
            alejandra
            nodejs
            corepack
            python3 # For systems that do not ship with Python by default (required by `node-gyp`)
            deno
            bun
          ];
        };
      }
    );
  };
}
