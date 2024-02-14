{ ... }:
{
  /*
    services.caddy = {
    enable = true;
    virtualHosts."jellyfin.arthurfernandes.com".extraConfig = ''
      reverse_proxy :8096
    '';
    };
  */

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  /*
    services.cloudflared = {
    enable = true;
    };
  */
}
