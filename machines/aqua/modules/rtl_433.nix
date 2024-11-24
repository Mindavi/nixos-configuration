{
  config,
  pkgs,
  ...
}:
{
  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
  environment.systemPackages = with pkgs; [
    rtl_433
  ];
  systemd.services.rtl_433 = {
    wantedBy = [ "multi-user.target" ];
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    description = "rtl_433 listener daemon";
    serviceConfig = {
      Type = "exec";
      # See https://github.com/merbanan/rtl_433/pull/2863 for prometheus support
      ExecStart = "${pkgs.rtl_433}/bin/rtl_433 -F http -F json -F \"mqtt://localhost:1884,user=rtl_433,pass=rtl_433_pass,retain=0\"";
      DynamicUser = "yes";
      SupplementaryGroups = [ "plugdev" ];
      Restart = "on-failure";
      RestartSec = "10s";
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
    };
  };
}
