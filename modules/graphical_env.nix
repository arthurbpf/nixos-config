{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    glxinfo
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
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    webcord
    vesktop
    spotify
    parsec-bin
    rustdesk
    droidcam
    slack
    pinta
    libreoffice

    nwg-look
    waybar
    libappindicator
    wofi
    wofi-emoji
    bemoji
    wl-clipboard
    wtype
    wdisplays
    dunst
    copyq
    grimblast
    unstable.swww
    unstable.swayidle
    unstable.swaylock-effects
    grim
    slurp

    pywal
    wpgtk
    wallust

    ungoogled-chromium

    udiskie
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  programs.xwayland.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.unstable.xdg-desktop-portal-gtk
    ];
  };

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
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

  services.udisks2.enable = true;
}
