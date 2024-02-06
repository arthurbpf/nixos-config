{ pkgs
, config
, ...
}: {
  imports = [
    ../modules/syncthing.nix
  ];

  home = {
    username = "arthur";
    homeDirectory = "/home/arthur";

    file."${config.home.homeDirectory}" = { source = ./old_dotfiles; recursive = true; };

    # User specific packages
    packages = with pkgs; [
      (retroarch.override {
        cores = with libretro; [
          nestopia
          bsnes
          swanstation
          mgba
        ];
        settings = {
          joypad_autoconfig_dir = "~/.config/retroarch/autoconfig";
          input_joypad_driver = "sdl2";
          menu_driver = "xmb";
          network_on_demand_thumbnails = "true";
          assets_directory = "${pkgs.retroarch-assets}/share/retroarch/assets";
          savefiles_in_content_dir = "true";
          savestates_in_content_dir = "true";
          menu_show_core_updater = "true";
          libretro_info_path = "${pkgs.libretro-core-info}/share/retroarch/cores";
          video_fullscreen = "true";
          input_menu_toggle_gamepad_combo = "4";
          cheevos_enable = "true";
          cheevos_username = "arthurbpf";
          cheevos_password = "WcxPki9cigoC%KaozS3#";
          cheevos_hardcore_mode_enable = "true";
        };
      })
    ];

    stateVersion = "23.11";
  };

  programs = {
    # Enable home-manager and git
    git.enable = true;

    # SSH
    ssh = {
      enable = true;
      extraConfig = "
  Host github.com
      User git
      IdentityFile ~/.ssh/github
  ";
    };

    # Zathura - a lightweight PDF viewer
    zathura = {
      enable = true;
      mappings = {
        m = "page-right-to-left";
      };
      options = {
        selection-clipboard = "clipboard";
      };
    };
  };

  # Customize look and feel
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;

    gtk.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Dark";
      package = pkgs.orchis-theme;
    };

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
