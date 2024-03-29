{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
    pcmanfm
    logseq
    glxinfo
    zathura
    piper
    obs-studio
    mpv
    bitwarden
    calibre
    teamspeak_client
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    spotify
    parsec-bin
    rustdesk
    droidcam
    slack
    pinta
    libreoffice
    filezilla

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
    rofimoji
    picom
    nitrogen
    arandr
    xclip
    xsel
    flameshot
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
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    displayManager = {
      defaultSession = "none+i3";

      lightdm = {
        enable = true;
      };
    };

    # All layout options are listed on `man xkeyboard-config`
    layout = "us,us";
    xkbVariant = ",intl";
    xkbOptions = "grp:toggle";
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
