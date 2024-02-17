{ ... }:
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 32400 ];
    allowedUDPPorts = [ 32400 ];
  };
}
