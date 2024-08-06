{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule {
  pname = "ginlong-monitor";
  version = "unstable_2024-08-06";

  src = fetchFromGitHub {
    owner = "mindavi";
    repo = "ginlong-monitor";
    rev = "58d6c2b6769259227d19e92ddb125ed1de7aa926";
    hash = "sha256-eeLiZaAAMlq4xZbUpKt2l8RQXwqZ9GEDYmK5/e44hFM=";
  };

  vendorHash = "sha256-wCN6HpO0a9437gxBhXxjdZXNvhasQHGpcFjv4b7cc4g=";

  subPackages = [ "ginlongmonitor" "ginlongmqtt" "ginlongparse" ];

  # Don't strip, for me the symbols can be useful for debugging.
  #ldflags = [
  #  "-s"
  #  "-w"
  #];

  meta = {
    description = "Ginlong solar inverter monitoring";
    homepage = "https://github.com/Mindavi/ginlong-monitor";
    license = lib.licenses.mit;
    mainProgram = "ginlongparse";
  };
}
