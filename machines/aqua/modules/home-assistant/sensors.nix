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
          unique_id = "total_electricity_usage";
        }
        {
          platform = "min_max";
          name = "Total electricity production";
          entity_ids = [
            "sensor.energy_produced_tariff_1"
            "sensor.energy_produced_tariff_2"
          ];
          type = "sum";
          unique_id = "total_electricity_production";
        }
        {
          platform = "statistics";
          name = "ELectricity usage over last week";
          entity_id = "sensor.total_electricity_usage";
          state_characteristic = "average_linear";
          max_age = {
            days = 7;
          };
          unique_id = "electricity_usage_last_week";
        }
        {
          platform = "statistics";
          name = "ELectricity production over last week";
          entity_id = "sensor.total_electricity_production";
          state_characteristic = "average_linear";
          max_age = {
            days = 7;
          };
          unique_id = "electricity_production_last_week";
        }
      ];
    };
  };
}