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
    github-desktop

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
    swww
    swayidle
    swaylock-effects

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
      pkgs.xdg-desktop-portal-gtk
      # pkgs.xdg-desktop-portal-hyprland 
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
