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
          name = "Electricity usage over last week";
          entity_id = "sensor.total_electricity_usage";
          state_characteristic = "change";
          max_age = {
            days = 7;
          };
        }
        {
          platform = "statistics";
          name = "Electricity production over last week";
          entity_id = "sensor.total_electricity_production";
          state_characteristic = "change";
          max_age = {
            days = 7;
          };
        }
        {
          platform = "statistics";
          name = "Average power over last week";
          entity_id = "sensor.power_consumed";
          state_characteristic = "average_linear";
          max_age = {
            days = 7;
          };
        }
      ];
    };
  };
}