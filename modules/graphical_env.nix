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

    /*
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
    swww
    hypridle
    hyprlock
    grim
    slurp
    */

    pywal
    wpgtk
    wallust

    ungoogled-chromium

    udiskie

    rofi
    picom
    nitrogen
    arandr
  ];

  /*
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  programs.xwayland.enable = true;

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
  };

  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };
  */

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    displayManager.startx.enable = true;
  };

  programs.xss-lock = {
    enable = true;
  };
  programs.i3lock.enable = true;
  programs.dconf.enable = true;

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
