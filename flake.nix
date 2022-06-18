{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem flake-utils.lib.defaultSystems (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
        awesome-cv = pkgs.callPackage ./nix/awesome-cv.nix { };
      in rec {
        packages = {
          awesome-cv = pkgs.stdenvNoCC.mkDerivation rec {
            pname = "awesome-cv";
            version = "2022-05-26";
            tlType = "run";

            src = pkgs.fetchFromGitHub {
              owner = "posquit0";
              repo = "Awesome-CV";
              rev = "5b05d935658377c73a3456269d23a276b19804f7";
              sha256 = "sha256-Iz3d8CgLReoqQH6gI2w4HjwB7op4C5s7Hz5ssG/kRiM=";
            };

            dontUnpack = true;

            dontBuild = true;

            installPhase = ''
              runHook preInstall

              path="$out/tex/latex/awesome-cv"
              mkdir -p "$path"
              cp $src/awesome-cv.cls "$path/"

              runHook postInstall
            '';
          };
        };
        defaultPackage = packages.awesome-cv;
      });
}
