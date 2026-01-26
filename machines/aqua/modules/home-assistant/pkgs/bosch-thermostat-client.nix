{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  aiohttp,
  click,
  colorlog,
  pyaes,
  pytz,
  pyyaml,
  slixmpp,
  pdm-pep517,
  pytest-aiohttp,
}:

buildPythonPackage rec {
  pname = "bosch-thermostat-client";
  version = "0.28.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bosch-thermostat";
    repo = "bosch-thermostat-client-python";
    tag = "v${version}";
    hash = "sha256-xtfwdX4o/rdNiVaUI6+e+qZLazEV+7R9BPVrEr2ld6c=";
  };

  postPatch = ''
    # Somehow pytest thinks this is also a test...
    rm examples/example_test.py
    # Contains an invalid import (asynctest which is unmaintained and unsupported on python > 3.11).
    rm tests/test_gateway.py
    substituteInPlace tests/test_aes.py \
      --replace-fail "from bosch_thermostat_client.encryption import Encryption" "from bosch_thermostat_client.encryption.base import BaseEncryption"
  '';

  build-system = [
    pdm-pep517
    setuptools
  ];

  dependencies = [
    aiohttp
    click
    colorlog
    pyaes
    pytz
    pyyaml
    slixmpp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-aiohttp
  ];

  disabledTests = [
  ];

  # All tests appear to be broken.
  doCheck = false;

  pythonImportsCheck = [ "bosch_thermostat_client" ];

  meta = {
    description = "Python3 asyncio package to talk to Bosch thermostat devices";
    homepage = "https://github.com/bosch-thermostat/bosch-thermostat-client-python";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ mindavi ];
  };
}
