{
  description = "Binary packaging of ginkou and melwalletd";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.mozilla = { url = "github:mozilla/nixpkgs-mozilla"; flake = false; };
  inputs.melwalletd-flake.url = "github:themeliolabs/melwalletd";
  inputs.ginkou-flake.url = "github:themeliolabs/ginkou";
  inputs.ginkou-loader-flake.url = "github:themeliolabs/ginkou-loader";

  outputs =
    { self
    , nixpkgs
    , mozilla
    , flake-utils
    , melwalletd-flake
    , ginkou-loader-flake
    , ginkou-flake
    , ...
    } @inputs:
    let
      rust_channel = "1.52.0";
      rust_sha256 = "sha256-fcaq7+4shIvAy0qMuC3nnYGd0ZikkR5ln/rAruHA6mM=";
      rustOverlay = final: prev:
        let rustChannel = prev.rustChannelOf {
          channel = rust_channel;
          sha256  = rust_sha256;
        };
        in
        { inherit rustChannel;
          rustc = rustChannel.rust;
          cargo = rustChannel.rust;
        };

    in flake-utils.lib.eachDefaultSystem
      #["x86_64-linux"]
      (system: let

        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import "${mozilla}/rust-overlay.nix")
            rustOverlay
          ];
        };

        rustPlatform = let rustChannel = pkgs.rustChannelOf {
            channel = rust_channel;
            sha256  = rust_sha256;
          }; in
            pkgs.makeRustPlatform {
              cargo = rustChannel.rust;
              rustc = rustChannel.rust;
            };

        melwalletd = melwalletd-flake.packages."${system}".melwalletd;
        ginkou = ginkou-flake.packages."${system}".ginkou;
        ginkou-loader = ginkou-loader-flake.packages."${system}".ginkou-loader;

        bundle = pkgs.callPackage ./bundle.nix {
          inherit melwalletd ginkou ginkou-loader;
          #start-script = ./start-ginkou.sh;
        };

        in rec {
          packages.bundle = bundle;

          # Produces ginkou binary and melwalletd linked binary
          defaultPackage = bundle;

          /*
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              docker
              #packages.tauri
            ] ++ tauri-deps;

            shellHook = ''
              export OPENSSL_DIR="${pkgs.openssl.dev}"
              export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib"

              # melwalletd
              export PATH=$PATH:${melwalletd}/bin

              # Copy in ginkou repo
              cp -r ${ginkou} ./ginkou

              # Make writable for building
              chmod +w ginkou
              chmod +w ginkou/public
              mkdir ginkou/public/build

              # Place into project with target triplet for bundling
              cp ${melwalletd}/bin/melwalletd ./src-tauri/melwalletd-$(gcc -dumpmachine)

              # Tauri cli
              export PATH=$PATH:${packages.tauri}/bin
              alias tauri='cargo-tauri tauri'
            '';
          };
          */
        });
}
