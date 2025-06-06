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
            name = "Temperature (ch1)";
            object_id = "temperature_bresser_portable_1";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/1/+/temperature_C";
            unit_of_measurement = "°C";
            device_class = "temperature";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Temperature (ch2)";
            object_id = "temperature_bresser_portable_2";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/2/+/temperature_C";
            unit_of_measurement = "°C";
            device_class = "temperature";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Temperature (ch3)";
            object_id = "temperature_bresser_portable_3";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/181/temperature_C";
            unit_of_measurement = "°C";
            device_class = "temperature";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Humidity (ch1)";
            object_id = "humidity_bresser_portable_1";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/1/+/humidity";
            unit_of_measurement = "%";
            device_class = "humidity";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Humidity (ch2)";
            object_id = "humidity_bresser_portable_2";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/2/+/humidity";
            unit_of_measurement = "%";
            device_class = "humidity";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Humidity (ch3)";
            object_id = "humidity_bresser_portable_3";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/181/humidity";
            unit_of_measurement = "%";
            device_class = "humidity";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Battery status (ch1)";
            object_id = "battery_status_bresser_portable_1";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/1/+/battery_ok";
            state_class = "measurement";
          }
          {
            name = "Battery status (ch2)";
            object_id = "battery_status_bresser_portable_2";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/2/+/battery_ok";
            state_class = "measurement";
          }
          {
            name = "Battery status (ch3)";
            object_id = "battery_status_bresser_portable_3";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/181/battery_ok";
            state_class = "measurement";
          }
          {
            name = "Temperature shed";
            object_id = "temperature_outside";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/4/temperature_C";
            unit_of_measurement = "°C";
            device_class = "temperature";
            force_update = true;
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Humidity shed";
            object_id = "humidity_outside";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/4/humidity";
            unit_of_measurement = "%";
            device_class = "humidity";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Temperature shed battery status";
            object_id = "temperature_outside_battery_status";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/4/battery_ok";
            state_class = "measurement";
          }
          # Override OpenMqttGateway specificity for some channels.
          # https://docs.openmqttgateway.com/integrate/home_assistant.html#rtl-433-auto-discovery-specificity
          # {
          #   state_topic = "+/+/RTL_433toMQTT/Nexus-TH/1/+";
          # }
          # {
          #   state_topic = "+/+/RTL_433toMQTT/Nexus-TH/2/+";
          # }
        ];
      };
    };
  };
}
