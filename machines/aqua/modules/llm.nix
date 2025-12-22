{ pkgs, config, ... }:

{
  services.ollama = {
    enable = false;
    port = 11434;
    loadModels = [ ];
  };
}
