{ ... }:

{
  services.home-assistant = {
    config = {
      input_number = {
        # Some sliders to simulate energy users in the house.
        vijverpomp_power = {
          name = "Vijverpomp vermogen";
          unit_of_measurement = "W";
          initial = 120;
          min = 0;
          max = 140;
          step = 10;
          mode = "slider";
        };
        tvset_power = {
          name = "Televisieset vermogen";
          unit_of_measurement = "W";
          initial = 30;
          min = 10;
          max = 200;
          step = 5;
          mode = "slider";
        };
        koelkast_vriezer_buiten_power = {
          name = "Koelvriescombinatie buiten vermogen";
          unit_of_measurement = "W";
          initial = 60;
          min = 0;
          max = 100;
          step = 5;
          mode = "slider";
        };
        koelkast_keuken_binnen_power = {
          name = "Koelkast keuken binnen vermogen";
          unit_of_measurement = "W";
          initial = 20;
          min = 0;
          max = 100;
          step = 5;
          mode = "slider";
        };
        pomp_vloerverwarming_power = {
          name = "Vloerverwarmingspomp vermogen";
          unit_of_measurement = "W";
          initial = 44;
          min = 0;
          max = 100;
          step = 5;
          mode = "slider";
        };
        kleine_verbruikers_power = {
          name = "Kleine verbruikers vermogen";
          unit_of_measurement = "W";
          initial = 5;
          min = 0;
          max = 50;
          step = 0.5;
          mode = "slider";
        };
      };
    };
  };
}
