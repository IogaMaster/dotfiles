{
  description = "You could not live with your own failure. Where did that bring you? Back to me. - Thanos";

  inputs = {
    # Core
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # For nixd
    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
    };

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";
    persist-retro.url = "github:Geometer1729/persist-retro";

    # Home
    neovim = {
      url = "github:IogaMaster/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:IogaMaster/nix-colors";
    prism.url = "github:IogaMaster/prism";

    # Deployments
    arion.url = "github:hercules-ci/arion";
    arion.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    nix-topology.url = "github:oddlama/nix-topology";
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    # Misc
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    dzgui.url = "github:jiriks74/dzgui.flake";

    flux.url = "github:IogaMaster/flux";
  };

  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "dotfiles";
            title = "dotfiles";
          };

          namespace = "custom";
        };
      };
    in
    (lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-24.8.6"
          "dotnet-sdk-6.0.428"
          "dotnet-runtime-6.0.36"
        ];
      };

      overlays = with inputs; [
        neovim.overlays.default
        nix-topology.overlays.default
        flux.overlays.default
      ];

      systems.modules.nixos = with inputs; [
        nix-topology.nixosModules.default
        disko.nixosModules.disko
        {
          # Required for impermanence
          fileSystems."/persist".neededForBoot = true;
        }
        flux.nixosModules.flux
        nix-flatpak.nixosModules.nix-flatpak
      ];

      systems.hosts.equinox.modules = with inputs; [
        (import ./disks/default.nix {
          inherit lib;
          device = "/dev/sda";
        })
      ];

      systems.hosts.zodiac.modules = with inputs; [
        # impermanence.nixosModules.impermanence
        (import ./disks/default.nix {
          inherit lib;
          device = "/dev/sda";
        })
      ];

      systems.hosts.aurora.modules = with inputs; [
        (import ./disks/default.nix {
          inherit lib;
          device = "/dev/nvme0n1";
        })
        {
          # Required for impermanence
          fileSystems."/persist".neededForBoot = true;
        }
      ];

      systems.hosts.orion.modules = with inputs; [
        (import ./disks/default.nix { inherit lib; })
      ];

      deploy = lib.mkDeploy { inherit (inputs) self; };

      checks = builtins.mapAttrs (
        _system: deploy-lib: deploy-lib.deployChecks inputs.self.deploy
      ) inputs.deploy-rs.lib;

      templates = import ./templates { };

      topology =
        with inputs;
        let
          host = self.nixosConfigurations.${builtins.head (builtins.attrNames self.nixosConfigurations)};
        in
        import nix-topology {
          inherit (host) pkgs; # Only this package set must include nix-topology.overlays.default
          modules = [
            (import ./topology {
              inherit (host) config;
            })
            { inherit (self) nixosConfigurations; }
          ];
        };
    })
    # Outputs not managed by snowfall.
    // {
      hydraJobs = {
        packages = {
          inherit (inputs.self.packages) "x86_64-linux";
        };
      };
    };
}
