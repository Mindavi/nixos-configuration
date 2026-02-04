{
  config,
  lib,
  pkgs,
  ...
}:
{
  # streaming
  #programs.obs-studio = {
  #  enable = true;
  #  package = (
  #    pkgs.obs-studio.override {
  #      cudaSupport = true;
  #    }
  #  );
  #  plugins = with pkgs.obs-studio-plugins; [
  #    droidcam-obs
  #    obs-text-pthread
  #  ];
  #};
}
