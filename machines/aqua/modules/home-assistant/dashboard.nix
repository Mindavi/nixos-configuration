{ ... }:
{
  services.home-assistant = {
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
                {
                  entity = "sensor.thermometer_portable_with_display_temperature";
                  name = "Draagbare sensor (hal)";
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
                  entity = "sensor.humidity_outside";
                  name = "Buiten";
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
                {
                  entity = "sensor.thermometer_portable_with_display_humidity";
                  name = "Draagbare sensor (hal)";
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
                  name = "Energiemeter verbruik";
                }
                {
                  entity = "sensor.power_produced";
                  name = "Energiemeter productie";
                }
                {
                  entity = "sensor.shellyplug_4ba4f7_power";
                  name = "Laptop";
                }
                {
                  entity = "sensor.shellyplug_4ad3c1_power";
                  name = "Quooker";
                }
                {
                  entity = "sensor.shellyplug_4a0038_power";
                  name = "Server en computer";
                }
                {
                  entity = "sensor.smart_energy_plug_freezer_power";
                  name = "Vriezer";
                }
                {
                  entity = "sensor.current_power";
                  name = "Zonnepanelen";
                }
              ];
            }
            {
              type = "entities";
              title = "Afgelopen week";
              show_header_toggle = false;
              entities = [
                {
                  entity = "sensor.electricity_usage_over_last_week_v3";
                  name = "Stroomverbruik";
                }
                {
                  entity = "sensor.electricity_production_over_last_week_v3";
                  name = "Stroomopwek";
                }
                {
                  entity = "sensor.gas_usage_over_last_week";
                  name = "Gasverbruik";
                }
              ];
            }
            {
              type = "markdown";
              title = "Verbruikers";
              content = ''
                {% set server = float(states('sensor.shellyplug_4a0038_power')) %}
                {% set quooker = float(states('sensor.shellyplug_4ad3c1_power')) %}
                {% set laptop = float(states('sensor.shellyplug_4ba4f7_power')) %}
                {% set vriezerbinnen = float(states('sensor.smart_energy_plug_freezer_power')) %}
                {% set vijverpomp_power = float(states('input_number.vijverpomp_power')) %}
                {% set tvset_power = float(states('input_number.tvset_power')) %}
                {% set koelkast_vriezer_buiten_power = float(states('input_number.koelkast_vriezer_buiten_power')) %}
                {% set koelkast_keuken_binnen_power = float(states('input_number.koelkast_keuken_binnen_power')) %}
                {% set pomp_vloerverwarming_power = float(states('input_number.pomp_vloerverwarming_power')) %}
                {% set kleine_verbruikers_power = float(states('input_number.kleine_verbruikers_power')) %}
                - Server: {{server}}W
                - Quooker: {{quooker}}W
                - Laptop: {{laptop}}W
                - Vriezer binnen: {{vriezerbinnen}}W
                {% set total = server + quooker + laptop + vriezerbinnen + vijverpomp_power + tvset_power + koelkast_vriezer_buiten_power + koelkast_keuken_binnen_power + pomp_vloerverwarming_power + kleine_verbruikers_power %}
                - Totaal: {{total|round(3)}}W
                - Huidig: {{float(states('sensor.power_consumed')) - float(states('sensor.power_produced'))}}W
              '';
            }
            {
              type = "entities";
              title = "Verbruikers simulatie";
              show_header_toggle = false;
              entities = [
                {
                  entity = "input_number.vijverpomp_power";
                }
                {
                  entity = "input_number.tvset_power";
                }
                {
                  entity = "input_number.koelkast_vriezer_buiten_power";
                }
                {
                  entity = "input_number.koelkast_keuken_binnen_power";
                }
                {
                  entity = "input_number.pomp_vloerverwarming_power";
                }
                {
                  entity = "input_number.kleine_verbruikers_power";
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
                  entity = "sensor.total_electricity_usage";
                  name = "Stroomverbruik";
                }
                {
                  entity = "sensor.total_electricity_production";
                  name = "Stroomopwek";
                }
                {
                  entity = "sensor.total_energy_generated";
                  name = "Stroomopwek zonnepanelen";
                }
              ];
            }
            {
              type = "entities";
              title = "Gemiddeld verbruik";
              show_header_toggle = false;
              entities = [
                {
                  entity = "sensor.avg_power_24h_shellyplug_4ba4f7";
                  name = "Laptop";
                }
                {
                  entity = "sensor.avg_power_24h_shellyplug_4ad3c1";
                  name = "Quooker";
                }
                {
                  entity = "sensor.avg_power_24h_shellyplug_4a0038";
                  name = "Server, router en computer";
                }
                {
                  entity = "sensor.avg_power_24h_smart_energy_plug_freezer";
                  name = "Vriezer";
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
