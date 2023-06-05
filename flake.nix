{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.05";
    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, crane }:
    let 
      supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux"];
    in
    utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.oura = crane.lib.${system}.buildPackage {
          src = self;
          cargoBuildCommand = "cargo build --features=webhook";
          buildInputs = [ pkgs.openssl ];
          nativeBuildInputs = [ pkgs.pkg-config ];
        };
        packages.default = self.packages.${system}.oura;
      }
    );
}
