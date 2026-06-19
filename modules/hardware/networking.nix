{ lib, ... }@args:
lib.mkModule args "ioga.hardware.networking" {
  options =
    with lib;
    with lib.types;
    {
      interface = mkOpt str "" "Name of interface";
      staticAddress = mkOpt str "" "Static ipv4 address";
    };
  config =
    { cfg }:
    {
      environment.persist.directories = [ "/etc/NetworkManager" ];
      networking = {
        networkmanager.enable = true;
        nameservers = [ "9.9.9.9" ];

        interfaces.${cfg.interface} = {
          name = cfg.interface;
          ipv4.addresses = [
            {
              address = cfg.staticAddress;
              prefixLength = 24;
            }
          ];
        };

        firewall.enable = true;

        # block all ai
        extraHosts = ''
          # --- OpenAI / ChatGPT ---
          127.0.0.1 chatgpt.com
          127.0.0.1 www.chatgpt.com
          127.0.0.1 openai.com
          127.0.0.1 www.openai.com
          127.0.0.1 api.openai.com
          127.0.0.1 chat.openai.com
          127.0.0.1 platform.openai.com

          # --- Google Gemini / Bard / Ai Mode ---
          127.0.0.1 gemini.google.com
          127.0.0.1 bard.google.com
          127.0.0.1 ai.google.com
          127.0.0.1 makersuite.google.com
          127.0.0.1 google.com # Google sucks too
          127.0.0.1 www.google.com

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
      };
    };
}
