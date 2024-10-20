{ ... }:

{
  services.home-assistant = {
    config = {
      sensor = [
        {
          platform = "min_max";
          name = "Total electricity usage";
          entity_ids = [
            "sensor.energy_consumed_tariff_1"
            "sensor.energy_consumed_tariff_2"
          ];
          type = "sum";
        }
        {
          platform = "min_max";
          name = "Total electricity production";
          entity_ids = [
            "sensor.energy_produced_tariff_1"
            "sensor.energy_produced_tariff_2"
          ];
          type = "sum";
        }
        {
          platform = "statistics";
          name = "Electricity usage over last week v3";
          entity_id = "sensor.total_electricity_usage";
          state_characteristic = "change";
          max_age = {
            days = 7;
          };
          unique_id = "electricity_usage_over_last_week_v3";
        }
        {
          platform = "statistics";
          name = "Electricity production over last week v3";
          entity_id = "sensor.total_electricity_production";
          state_characteristic = "change";
          max_age = {
            days = 7;
          };
          unique_id = "electricity_production_over_last_week_v3";
        }
        {
          platform = "statistics";
          name = "Gas usage over last week";
          entity_id = "sensor.gas_consumed";
          state_characteristic = "change";
          max_age = {
            days = 7;
          };
          unique_id = "gas_usage_over_last_week";
        }
        /*
          # Enabling this causes 100% CPU usage of 1 core in home assistant and breaks the system.
          # Figure out how we can do this better, maybe by first averaging over 5 mins and then using those samples.
          # Likely just using average/mean will help? Then no time compares are required.
          {
            platform = "statistics";
            name = "Average power over last week v2";
            entity_id = "sensor.power_consumed";
            state_characteristic = "average_linear";
            max_age = {
              days = 7;
            };
            unique_id = "average_power_over_last_week_v2";
          }
        */
        {
          platform = "statistics";
          name = "Average power 24h shellyplug 4ba4f7";
          entity_id = "sensor.shellyplug_4ba4f7_power";
          state_characteristic = "mean";
          max_age = {
            hours = 24;
          };
        }
        {
          platform = "statistics";
          name = "Average power 24h shellyplug 4ad3c1";
          entity_id = "sensor.shellyplug_4ad3c1_power";
          state_characteristic = "mean";
          max_age = {
            hours = 24;
          };
        }
        {
          platform = "statistics";
          name = "Average power 24h shellyplug 4a0038";
          entity_id = "sensor.shellyplug_4a0038_power";
          state_characteristic = "mean";
          max_age = {
            hours = 24;
          };
        }
        {
          platform = "statistics";
          name = "Average power 24h smart energy plug freezer";
          entity_id = "sensor.smart_energy_plug_freezer_power";
          state_characteristic = "mean";
          max_age = {
            hours = 24;
          };
        }
        {
          platform = "min_max";
          name = "Total power estimation energy measurement and simulation";
          entity_ids = [
            "sensor.smart_energy_plug_freezer_power"
            "sensor.shellyplug_4a0038_power"
            "sensor.shellyplug_4ad3c1_power"
            "sensor.shellyplug_4ba4f7_power"
            "input_number.vijverpomp_power"
            "input_number.tvset_power"
            "input_number.koelkast_vriezer_buiten_power"
            "input_number.koelkast_keuken_binnen_power"
            "input_number.pomp_vloerverwarming_power"
            "input_number.kleine_verbruikers_power"
          ];
          type = "sum";
        }
      ];
    };
  };
}
