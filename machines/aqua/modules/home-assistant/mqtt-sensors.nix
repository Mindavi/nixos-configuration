{ config, ... }:
let
  mqtt_server_name = config.networking.hostName;
in
{
  services.home-assistant = {
    config = {
      # Broker must be set up via the web UI.
      mqtt = {
        sensor = [
          {
            name = "Temperature bedroom Rick";
            object_id = "temperature_bedroom_rick";
            state_topic = "sensor/temperature/bedroom/status";
            unit_of_measurement = "°C";
            device_class = "temperature";
            state_class = "measurement";
            expire_after = 300;
          }
          {
            name = "Temperature bedroom Rick 2";
            object_id = "temperature_bedroom_rick_2";
            state_topic = "sensor/temperature/bedroom/debug";
            unit_of_measurement = "°C";
            device_class = "temperature";
            state_class = "measurement";
            expire_after = 300;
          }
          {
            name = "Humidity bedroom Rick";
            object_id = "humidity_bedroom_rick";
            state_topic = "sensor/humidity/bedroom/status";
            unit_of_measurement = "%";
            device_class = "humidity";
            state_class = "measurement";
            expire_after = 300;
          }
          {
            name = "Temperature living room (ch1)";
            object_id = "temperature_bresser_portable_1";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/1/141/temperature_C";
            unit_of_measurement = "°C";
            device_class = "temperature";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Temperature washing room (ch2)";
            object_id = "temperature_bresser_portable_2";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/2/+/temperature_C";
            unit_of_measurement = "°C";
            device_class = "temperature";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Temperature pantry (ch3)";
            object_id = "temperature_bresser_portable_3";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/89/temperature_C";
            unit_of_measurement = "°C";
            device_class = "temperature";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Humidity living room (ch1)";
            object_id = "humidity_bresser_portable_1";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/1/141/humidity";
            unit_of_measurement = "%";
            device_class = "humidity";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Humidity washing room (ch2)";
            object_id = "humidity_bresser_portable_2";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/2/+/humidity";
            unit_of_measurement = "%";
            device_class = "humidity";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Humidity pantry (ch3)";
            object_id = "humidity_bresser_portable_3";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/89/humidity";
            unit_of_measurement = "%";
            device_class = "humidity";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Battery status living room (ch1)";
            object_id = "battery_status_bresser_portable_1";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/1/141/battery_ok";
            state_class = "measurement";
          }
          {
            name = "Battery status washing room (ch2)";
            object_id = "battery_status_bresser_portable_2";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/2/+/battery_ok";
            state_class = "measurement";
          }
          {
            name = "Battery status pantry (ch3)";
            object_id = "battery_status_bresser_portable_3";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/89/battery_ok";
            state_class = "measurement";
          }
          {
            name = "Temperature outside";
            object_id = "temperature_outside";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/4/temperature_C";
            unit_of_measurement = "°C";
            device_class = "temperature";
            force_update = true;
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Humidity outside";
            object_id = "humidity_outside";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/4/humidity";
            unit_of_measurement = "%";
            device_class = "humidity";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Temperature outside battery status";
            object_id = "temperature_outside_battery_status";
            #state_topic = "rtl_433/${mqtt_server_name}/devices/Hideki-Temperature/3/+/battery_ok";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/4/battery_ok";
            state_class = "measurement";
          }
          {
            name = "Total energy generated";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            unit_of_measurement = "kWh";
            device_class = "energy";
            state_class = "total_increasing";
            icon = "mdi:flash";
            value_template = "{{ value_json.Total }}";
          }
          {
            name = "Energy generated today";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            unit_of_measurement = "kWh";
            device_class = "energy";
            state_class = "total_increasing";
            icon = "mdi:flash";
            value_template = "{{ value_json.Today }}";
          }
          {
            name = "Energy generated yesterday";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            unit_of_measurement = "kWh";
            device_class = "energy";
            state_class = "total_increasing";
            icon = "mdi:flash";
            value_template = "{{ value_json.Yesterday }}";
          }
          {
            name = "Energy generated this month";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            unit_of_measurement = "kWh";
            device_class = "energy";
            state_class = "total_increasing";
            icon = "mdi:flash";
            value_template = "{{ value_json.Month }}";
          }
          {
            name = "Energy generated last month";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            unit_of_measurement = "kWh";
            device_class = "energy";
            state_class = "total_increasing";
            icon = "mdi:flash";
            value_template = "{{ value_json.LastMonth }}";
          }
          {
            name = "Inverter status";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            icon = "mdi:power";
            value_template = "{{ value_json.Status }}";
          }
          {
            name = "Current power";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            icon = "mdi:flash";
            unit_of_measurement = "W";
            value_template = "{{ value_json.PNow }}";
            device_class = "power";
            state_class = "measurement";
          }
          {
            name = "Voltage DC string 1";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            icon = "mdi:current-dc";
            unit_of_measurement = "V";
            value_template = "{{ value_json.Vdc1 }}";
            state_class = "measurement";
          }
          {
            name = "Voltage DC string 2";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            icon = "mdi:current-dc";
            unit_of_measurement = "V";
            value_template = "{{ value_json.Vdc2 }}";
            state_class = "measurement";
          }
          {
            name = "Current DC string 1";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            icon = "mdi:current-dc";
            unit_of_measurement = "A";
            value_template = "{{ value_json.Adc1 }}";
            state_class = "measurement";
          }
          {
            name = "Current DC string 2";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            unit_of_measurement = "A";
            icon = "mdi:current-dc";
            value_template = "{{ value_json.Adc2 }}";
            state_class = "measurement";
          }
          {
            name = "AC voltage";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            unit_of_measurement = "V";
            icon = "mdi:current-ac";
            value_template = "{{ value_json.Vac }}";
            state_class = "measurement";
          }
          {
            name = "AC current";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            unit_of_measurement = "A";
            icon = "mdi:current-ac";
            value_template = "{{ value_json.Aac }}";
            state_class = "measurement";
          }
          {
            name = "AC frequency";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            unit_of_measurement = "Hz";
            icon = "mdi:current-ac";
            value_template = "{{ value_json.Fac }}";
            state_class = "measurement";
          }
          {
            name = "Inverter temperature";
            state_topic = "sensor/inverter/ginlong-inverter-monitor/status";
            unit_of_measurement = "°C";
            value_template = "{{ value_json.Temperature }}";
            device_class = "temperature";
            state_class = "measurement";
          }
        ];
      };
    };
  };
}
