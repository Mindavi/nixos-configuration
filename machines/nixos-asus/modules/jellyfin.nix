{
  config,
  pkgs,
  ...
}:
{
  services.jellyfin = {
    enable = false;
    openFirewall = true;
    user = "rick";
  };

  # From the wiki: https://wiki.nixos.org/wiki/Jellyfin
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      #intel-vdpau-driver
      libvdpau-va-gl
      #vaapiVdpau
      #intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      # OpenCL support for intel CPUs before 12th gen
      # see: https://github.com/NixOS/nixpkgs/issues/356535
      intel-compute-runtime-legacy1
      vpl-gpu-rt # QSV on 11th gen or newer
      intel-media-sdk # QSV up to 11th gen
      intel-media-driver
    ];
  };
}
