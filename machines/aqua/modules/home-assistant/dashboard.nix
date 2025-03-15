{ ... }:
{
  services.home-assistant = {
    config.lovelace.mode = "storage";
    lovelaceConfig = null;
  };
}
