{
  description = "Go dev environment";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system} = rec {
        eww-ws = pkgs.buildGoModule {
          name = "eww-ws";
          src = ./.;
          vendorSha256 = "sha256-Ds78icxEE5DRlNJx8//ME5t3hP/FZQAHA4ZjVMK9h9Y=";
        };

        default = eww-ws;
      };

      devShells.${system} = {
        default = pkgs.mkShell { buildInputs = with pkgs; [ go gopls ]; };
      };
    };
}
