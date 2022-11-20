{
  inputs = {
    crane.url = "github:ipetkov/crane";
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-22.05";
  };

  outputs = {
    self,
    crane,
    utils,
    nixpkgs,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux"];
    pkgs = import nixpkgs {system= "x86_64-linux";};
  in
    utils.lib.eachSystem supportedSystems
    (
      system: {
        packages.oura = crane.lib.${system}.buildPackage {
          src = self;
          cargoBuildCommand = "cargo build --features=webhook";
          buildInputs = with pkgs; [
            openssl
          ];
          nativeBuildInputs = with pkgs; [
            pkg-config
          ];
        };
        packages.default = self.packages.${system}.oura;
      }
    );
}
