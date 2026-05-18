{
  pkgs,
  ...
}:

{
  hardware.sane = {
    enable = true;
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };
}
