{ config, ... }:

{
  sops.defaultSopsFile = ../../../secrets/aqua.yaml;
  sops.secrets = {
  };
}
