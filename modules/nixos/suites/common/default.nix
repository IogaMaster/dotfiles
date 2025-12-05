{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.suites.common;
in
{
  options.suites.common = with types; {
    enable = mkBoolOpt false "Enable the common suite";
  };

  config = mkIf cfg.enable {
    system.nix.enable = true;
    system.security.sudo.enable = true;

    hardware.audio.enable = true;
    hardware.networking.enable = true;

    apps.misc.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.settings = {
      General = {
        FastConnectable = true;
        JustWorksRepairing = "always";
        Privacy = "device";
      };
      Policy = {
        AutoEnable = true;
      };
      inputs = {
        UserSpaceHID = true;
      };
    };

    environment.persist.directories = [ "/etc/bluetooth" ];

    apps.pass.enable = true;
    apps.tools.git.enable = true;
    apps.tools.nix-ld.enable = true;

    services.ssh.enable = true;

    programs.dconf.enable = true;

    environment.systemPackages = [
      pkgs.bluetuith
      pkgs.custom.sys
      pkgs.deploy-rs
    ];

    networking.extraHosts = ''
      # --- OpenAI / ChatGPT ---
      127.0.0.1 chatgpt.com
      127.0.0.1 www.chatgpt.com
      127.0.0.1 openai.com
      127.0.0.1 www.openai.com
      127.0.0.1 api.openai.com
      127.0.0.1 chat.openai.com
      127.0.0.1 platform.openai.com

      # --- Google Gemini / Bard ---
      127.0.0.1 gemini.google.com
      127.0.0.1 bard.google.com
      127.0.0.1 ai.google.com
      127.0.0.1 makersuite.google.com

      # --- Anthropic Claude ---
      127.0.0.1 anthropic.com
      127.0.0.1 www.anthropic.com
      127.0.0.1 claude.ai
      127.0.0.1 www.claude.ai
      127.0.0.1 api.anthropic.com

      # --- Perplexity ---
      127.0.0.1 perplexity.ai
      127.0.0.1 www.perplexity.ai
      127.0.0.1 labs.perplexity.ai
      127.0.0.1 api.perplexity.ai

      # --- Meta AI ---
      127.0.0.1 meta.ai
      127.0.0.1 www.meta.ai
      127.0.0.1 ai.facebook.com

      # --- Mistral ---
      127.0.0.1 mistral.ai
      127.0.0.1 www.mistral.ai
      127.0.0.1 api.mistral.ai

      # --- xAI / Grok ---
      127.0.0.1 x.ai
      127.0.0.1 www.x.ai
      127.0.0.1 grok.x.ai
      127.0.0.1 api.x.ai

      # --- Cohere ---
      127.0.0.1 cohere.com
      127.0.0.1 www.cohere.com
      127.0.0.1 api.cohere.ai

      # --- HuggingFace Chat ---
      127.0.0.1 huggingface.co
      127.0.0.1 www.huggingface.co
      127.0.0.1 api-inference.huggingface.co

      # --- IBM Watson ---
      127.0.0.1 ibm.com
      127.0.0.1 cloud.ibm.com
      127.0.0.1 watson.ibm.com
    '';

    system = {
      fonts.enable = true;
      locale.enable = true;
      time.enable = true;
      xkb.enable = true;
    };
  };
}
