{ ... }:
{
  services.home-assistant = {
    config.lovelace.mode = "yaml";
    lovelaceConfig = {
      title = "Thuis";
      views = [
        {
          title = "Aansturing";
          cards = [
            {
              type = "light";
              entity = "light.lamp_slaapkamer_rick";
              name = "Slaapkamer Rick";
            }
          ];
        }
      ];
    };
  };
}
