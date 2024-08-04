{ ... }:
{
  services.home-assistant = {
    lovelaceConfig = {
      title = "Thuis";
      views = [
        {
          title = "Klimaat";
          cards = [
            {
              type = "entities";
              title = "Temperaturen";
              show_header_toggle = false;
              entities = [
                {
                  entity = "sensor.temperature_bedroom_rick";
                  name = "Slaapkamer Rick 1";
                }
                {
                  entity = "sensor.temperature_outside";
                  name = "Buiten";
                }
                {
                  entity = "sensor.temperature_bresser_portable_1";
                  name = "Woonkamer";
                }
                 {
                  entity = "sensor.temperature_bresser_portable_2";
                  name = "Washok";
                }
                 {
                  entity = "sensor.temperature_bresser_portable_3";
                  name = "Voorraadkast";
                }
              ];
            }
            {
              type = "entities";
              title = "Luchtvochtigheid";
              show_header_toggle = false;
              entities = [
                {
                  entity = "sensor.humidity_bedroom_rick";
                  name = "Slaapkamer Rick";
                }
                {
                  entity = "sensor.humidity_bresser_portable_1";
                  name = "Woonkamer";
                }
                {
                  entity = "sensor.humidity_bresser_portable_2";
                  name = "Washok";
                }
                {
                  entity = "sensor.humidity_bresser_portable_3";
                  name = "Voorraadkast";
                }
              ];
            }
          ];
        }
        {
          title = "Energie";
          cards = [
            {
              type = "entities";
              title = "Vermogen";
              show_header_toggle = false;
              entities = [
                {
                  entity = "sensor.power_consumed";
                  name = "Energiemeter";
                }
                {
                  entity = "sensor.shellyplug_4ad3c1_power";
                  name = "Televisieset";
                }
                {
                  entity = "sensor.shellyplug_4a0038_power";
                  name = "Server en computer";
                }
              ];
            }
            {
              type = "entities";
              title = "Totaal verbruik";
              show_header_toggle = false;
              entities = [
                {
                  entity = "sensor.gas_consumed";
                  name = "Gas";
                }
                {
                  entity = "sensor.energy_consumed_tariff_1";
                  name = "Stroomverbruik";
                }
                {
                  entity = "sensor.energy_produced_tariff_1";
                  name = "Stroomopwek";
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
