{
  config,
  lib,
  pkgs,
  ...
}:

{
  hardware.sane = {
    enable = true;
  };
}
