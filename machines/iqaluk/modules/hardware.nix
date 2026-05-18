{
  ...
}:

{
  hardware.bluetooth.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  hardware.cpu.amd.updateMicrocode = true;
}
