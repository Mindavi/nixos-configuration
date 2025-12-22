{ pkgs, config, ...}:

{
  services.ollama = {
    enable = true;
    port = 11434;
    loadModels = [
      "qwen3:4b"
      "deepseek-r1:8b"
    ];
  };
}

