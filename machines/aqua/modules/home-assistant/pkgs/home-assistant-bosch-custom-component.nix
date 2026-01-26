{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  callPackage,
}:

buildHomeAssistantComponent rec {
  owner = "bosch-thermostat";
  domain = "bosch";
  version = "0.28.2";

  src = fetchFromGitHub {
    owner = "bosch-thermostat";
    repo = "home-assistant-bosch-custom-component";
    rev = "v${version}";
    hash = "sha256-z4rf7sW+K8NgDQShEnVaXUAUeY+CXLlY3izV0cdGQEY=";
  };

  dependencies = [
    (callPackage ./bosch-thermostat-client.nix { })
  ];

  dontCheckManifest = false;

  meta = {
    description = "HA custom component for Bosch thermostats";
    homepage = "https://github.com/bosch-thermostat/home-assistant-bosch-custom-component";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mindavi
    ];
  };
}
