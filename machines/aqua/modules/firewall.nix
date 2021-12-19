{ pkgs, config, ... }:
{
  # Make sure firewall is enabled.
  networking.firewall.enable = true;

  networking.firewall.extraCommands = ''
    # mdns, zeroconf, avahi
    ip46tables -A nixos-fw -p udp -m udp -s 192.168.2.0/24 --dport 5353

    # mosquitto (insecure)
    ip46tables -A nixos-fw -p tcp -m tcp -s 192.168.2.0/24 --dport 1883
    
    # samba
    ip46tables -A nixos-fw -p tcp -m tcp -s 192.168.2.0/24 --dport 139
    ip46tables -A nixos-fw -p tcp -m tcp -s 192.168.2.0/24 --dport 445
    ip46tables -A nixos-fw -p udp -m udp -s 192.168.2.0/24 --dport 137
    ip46tables -A nixos-fw -p udp -m udp -s 192.168.2.0/24 --dport 138
  ''; 
}

