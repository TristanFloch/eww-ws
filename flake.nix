{
  description = "Go dev environment";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in rec {
      packages.${system} = {
        eww-ws = pkgs.buildGoModule {
          name = "eww-ws";
          src = ./.;
          vendorSha256 = "sha256-ef3r3Rrepj+3pAxXufA63h0SNwikdcCOLfg0ooDTnD8=";
        };

        default = packages.${system}.eww-ws;
      };

      devShells.${system} = {
        default = pkgs.mkShell {
          buildInputs = [ pkgs.go pkgs.gopls packages.${system}.eww-ws ];
        };
      };
    };
}
