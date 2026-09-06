{
  lib,
  pkgs,
  inputs,
  config,
  ...
}@args:
lib.mkModule args "ioga.services.llms" {
  options.enable = lib.mkBoolOpt' false; # Service is opt-in by default

  config =
    { cfg }:
    let
      # Safe extraction of the system platform string
      system = pkgs.stdenv.hostPlatform.system;

      # Extract the pi-coding-agent binary from the flake inputs safely
      piAgent = inputs.llm-agents.packages.${system}.pi-coding-agent or pkgs.pi-coding-agent;
    in
    {
      # 1. System Level: Core packages and sandboxing utilities
      environment.systemPackages = [
        piAgent
        pkgs.bubblewrap # Used by Pi's runtime environment for isolated commands
      ];

      # 2. System Level: GPU-Accelerated Ollama Background Engine
      services.ollama = {
        enable = true;
        package = pkgs.ollama-rocm;
      };

      # 3. System Level: Global Environment variables for Hyprland and local inference
      environment.sessionVariables = {
        # Global local AI targets
        AI_BASE_URL = "http://localhost:11434/v1";
        AI_API_KEY = "ollama";
        AI_MODEL = "gemma4:26b"; # Ready out-of-the-box for Gemma

        # Hyprland fix for Electron/AI tools
        NIXOS_OZONE_WL = "1";
      };

    };
}
