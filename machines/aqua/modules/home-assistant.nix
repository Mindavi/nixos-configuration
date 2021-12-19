{ pkgs, config, ...}:
let
  hassWithoutInstallCheck = pkgs.home-assistant.overrideAttrs (oldAttrs: {
    doInstallCheck = false;
  });
in {
  services.home-assistant = {
    port = 8123;
    package = hassWithoutInstallCheck.override {
      extraComponents = [
        "default_config"
        "discovery"
        "history"
        "html5"
        "http"
        "local_ip" # ???
        "logbook"
        "lovelace"
        #"minecraft_server"
        "mqtt"
        "shelly"
      ];
    };
    # Use a proxy.
    openFirewall = false;
    enable = true;
    configDir = "/var/lib/hass";
  };
}

