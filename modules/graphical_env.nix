{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
    zathura
    pcmanfm
    piper
    obs-studio
    mpv
    remmina
    bitwarden
    calibre
    teamspeak_client
    webcord
    spotify
    parsec-bin

    nwg-look
    waybar
    libappindicator
    wofi
    bemoji
    wl-clipboard
    wtype
    wdisplays
    dunst
    copyq
    grimblast
    mpvpaper
    hyprpaper
    swww
    swayidle
    swaylock-effects

    pywal
    wpgtk
    wallust

    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

    ungoogled-chromium
  ];

  # Enable greetd
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "arthur";
      };
      default_session = initial_session;
    };
  };


  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = {
      packages = with pkgs; [
        tridactyl-native
      ];
    };
  };
}
