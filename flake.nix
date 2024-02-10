{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    lite-system.url = "github:yelite/lite-system";

    # https://github.com/lnl7/nix-darwin
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/nix-community/home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/nix-community/emacs-overlay
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({inputs, ...}: {
      imports = [
        inputs.lite-system.flakeModule
      ];

      config = {
        lite-system = {
          nixpkgs = {
            config = {
              allowUnfree = true;
            };

            overlays = [
              inputs.emacs-overlay.overlays.emacs
            ];
          };

          systemModule = ./system;
          homeModule = ./home;
          hostModuleDir = ./host;

          hosts = {
            aarch64-darwin = {
              system = "aarch64-darwin";
            };

            x86-darwin = {
              system = "x86_64-darwin";
            };
          };
        };
      };
    });
}
