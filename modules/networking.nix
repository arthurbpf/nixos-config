{ pkgs, ... }:
{
  # Enable networking

  # systemd.services.NetworkManager-wait-online.enable = false;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];

  networking = {
    networkmanager = {
      enable = true;
      dispatcherScripts = [
        {
          source = pkgs.writeText "basicHook" ''
            enable_disable_wifi ()
            {
                result=$(${pkgs.networkmanager}/bin/nmcli dev | grep "ethernet" | grep -w "connected")
                if [ -n "$result" ]; then
                    ${pkgs.networkmanager}/bin/nmcli radio wifi off
                else
                    ${pkgs.networkmanager}/bin/nmcli radio wifi on
                fi
            }

            if [ "$2" = "up" ]; then
                enable_disable_wifi
            fi

            if [ "$2" = "down" ]; then
                enable_disable_wifi
            fi
          '';
        }
      ];
    };
  };
}
