{ ... }:

{
  services.home-assistant = {
    config = {
      input_number = {
        # Some sliders to simulate energy users in the house.
        vijverpomp_power = {
          name = "vijverpomp vermogen";
          unit_of_measurement = "W";
          initial = 120;
          min = 0;
          max = 140;
          step = 10;
          mode = "slider";
        };
        tvset_power = {
          name = "televisieset vermogen";
          initial = 30;
          min = 10;
          max = 200;
          step = 5;
          mode = "slider";
        };
        koelkast_vriezer_buiten_power = {
          name = "Koelvriescombinatie buiten vermogen";
          initial = 60;
          min = 0;
          max = 100;
          step = 5;
          mode = "slider";
        };
        koelkast_keuken_binnen_power = {
          name = "Koelkast keuken binnen vermogen";
          initial = 20;
          min = 0;
          max = 100;
          step = 5;
          mode = "slider";
        };
        pomp_vloerverwarming_power = {
          name = "Vloerverwarmingspomp vermogen";
          initial = 20;
          min = 0;
          max = 100;
          step = 5;
          mode = "slider";
        };
        kleine_verbruikers_power = {
          name = "Kleine verbruikers vermogen";
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
