{
  # inspired by: https://serokell.io/blog/practical-nix-flakes#packaging-existing-applications
  description = "Build network";
  inputs.nixpkgs.url = "nixpkgs";
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      });
    in
    {
      overlay = (final: prev: { });
      packages = forAllSystems (system: { });
      defaultPackage = forAllSystems (system: self.packages.${system}.haskell-hello);
      devShell = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in
        pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            nixops
          ];

          # Change the prompt to show that you are in a devShell
          shellHook = "
            export PS1='\\e[1;32mnix@$PWD$ \\e[0m'
          ";
        });
    };
}
