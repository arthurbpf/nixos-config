{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wine-staging
    lutris
    gamemode
    pcsx2
    rpcs3
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  programs.gamescope.enable = true;
  hardware.steam-hardware.enable = true; # Enables steam controllers and supported hardware udev rules
  hardware.uinput.enable = true;

  services.udev = {
    enable = true;
    packages = with pkgs; [ game-devices-udev-rules ];
    extraRules = "
      # 8BitDo Micro; Bluetooth (D-Mode)\n
      SUBSYSTEM==\"input\",ATTRS{id/vendor}==\"2dc8\", ATTRS{id/product}==\"9020\", ATTRS{name}==\"8BitDo Micro gamepad\", ENV{ID_INPUT_JOYSTICK}=\"1\", TAG+=\"uaccess\"
      # Retroarch
      KERNEL==\"event*\", NAME=\"input/%k\", MODE=\"666\"
    ";
  };

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };

  services.ratbagd.enable = true;
}
