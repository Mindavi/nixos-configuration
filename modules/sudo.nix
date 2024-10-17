{
  config,
  lib,
  pkgs,
  ...
}:
{
  security.sudo = {
    package = pkgs.sudo.override {
      withInsults = true;
    };
    execWheelOnly = true;
    extraConfig = ''
      Defaults insults
    '';
  };
}
