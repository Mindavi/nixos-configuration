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
                  entity = "sensor.shellyplug_4ba4f7_power";
                  name = "Laptop";
                }
                {
                  entity = "sensor.shellyplug_4ad3c1_power";
                  name = "Televisieset";
                }
                {
                  entity = "sensor.shellyplug_4a0038_power";
                  name = "Server en computer";
                }
                {
                  entity = "sensor.current_power";
                  name = "Zonnepanelen";
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
                {% set vijverpompmin = 120 %}
                {% set vijverpompmax = 140 %}
                {% set tvset = states('sensor.shellyplug_4ad3c1_power') %}
                {% set tvsetmin = float(tvset, default=10) %}
                {% set tvsetmax = float(tvset, default=150) %}
                {% set server = states('sensor.shellyplug_4a0038_power') %}
                {% set servermin = float(server, default=15) %}
                {% set servermax = float(server, default=100) %}{# Not very sure about this... Needs more testing. #}
                {% set koelvriesbuiten = 60 %}
                {% set vriezerbinnen = 45 %}
                {% set koelkastbinnen = '?' %}
                - Vijverpomp: {{vijverpompmin}}-{{vijverpompmax}}W
                - Koelvriescombinatie buiten: ~{{koelvriesbuiten}}W
                - Vriezer binnen: ~{{vriezerbinnen}}W
                - Koelkast binnen: {{koelkastbinnen}}W
                - Quooker: ?W (lijkt niet veel te zijn, tenzij aan het verwarmen)
                - Pomp vloerverwarming: ?W
                - Televisieset: {{float(tvset, default='tussen ' + tvsetmin|string + '-' + tvsetmax|string)}}W
                - Server, computer en printer: {{float(server, default='tussen ' + servermin|string + '-' + servermax|string)}}W

                {% set totalmin = (vijverpompmin + tvsetmin + servermin + koelvriesbuiten + vriezerbinnen)|round %}
                {% set totalmax = (vijverpompmax + tvsetmax + servermax + koelvriesbuiten + vriezerbinnen)|round %}
                - Totaal minimum: {{totalmin}}
                - Totaal maximum: {{totalmax}}
                - Huidig: {{states('sensor.power_consumed')}}
              '';
            }
          ];
        }
      ];
    };
  };
}
