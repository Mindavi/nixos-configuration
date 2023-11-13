{ pkgs, config, ... }:
let
  subnet = "192.168.1.0/24";
  #subnet = "10.0.2.0/24";
in
{
  # Make sure firewall is enabled.
  networking.firewall.enable = true;

  # Open up 8000 for testing purposes.
  networking.firewall.allowedTCPPorts = [ 8000 ];

  networking.firewall.extraCommands = ''
    # mdns, zeroconf, avahi
    iptables -A nixos-fw -p udp -m udp -s ${subnet} --dport 5353 -j nixos-fw-accept

    # mosquitto (insecure)
    iptables -A nixos-fw -p tcp -m tcp -s ${subnet} --dport 1883 -j nixos-fw-accept
    
    # samba
    iptables -A nixos-fw -p tcp -m tcp -s ${subnet} --dport 139 -j nixos-fw-accept
    iptables -A nixos-fw -p tcp -m tcp -s ${subnet} --dport 445 -j nixos-fw-accept
    iptables -A nixos-fw -p udp -m udp -s ${subnet} --dport 137 -j nixos-fw-accept
    iptables -A nixos-fw -p udp -m udp -s ${subnet} --dport 138 -j nixos-fw-accept

    # home assistant (FIXME: to be removed again)
    iptables -A nixos-fw -p tcp -m tcp -s ${subnet} --dport 8123 -j nixos-fw-accept
  '';
}

