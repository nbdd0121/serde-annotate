{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShells.default =
          (pkgs.buildFHSUserEnv {
            name = "serde-annotate";
            targetPkgs = pkgs:
              with pkgs; [
                bazel
                rustup
                zlib
                openssl
                (curl.override {inherit openssl;})
              ];
          })
          .env;

        formatter = pkgs.alejandra;
      }
    );
}
