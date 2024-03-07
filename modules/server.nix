{ config, ... }:
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 32400 ];
    allowedUDPPorts = [ 32400 ];
  };

  services.cloudflared = {
    enable = false;
  };

  services.terraria = {
    enable = false;
    port = 7777;
    maxPlayers = 32;
    dataDir = config.users.users.server.home + "/terraria";
  };
}
