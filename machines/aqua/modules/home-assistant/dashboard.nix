{ ... }:
{
  services.home-assistant = {
    config.lovelace = {
      resource_mode = "storage";
    };
    lovelaceConfig = null;
  };
}
