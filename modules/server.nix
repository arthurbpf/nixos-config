{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cloudflared
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 32400 ];
    allowedUDPPorts = [ 32400 ];
  };

  services = {
    zerotierone = {
      enable = true;
      port = 9993;
    };
  };

  /*
    services.cloudflared = {
    enable = true;
    user = "server";

    tunnels = {
      "13e434b2-5478-4cc8-b206-3b556adf0b37" = {
        credentialsFile = "/home/server/.cloudflared/13e434b2-5478-4cc8-b206-3b556adf0b37.json";
        default = "http_status:404";
        ingress = {
          "terraria.arthurfernandes.com".service = "tcp://127.0.0.1:7777";
        };
      };
    };
    };

    services.terraria = {
    enable = false;
    port = 7777;
    maxPlayers = 32;
    dataDir = "/mnt/storage/server/apps/terraria-server";
    };
  */
}
