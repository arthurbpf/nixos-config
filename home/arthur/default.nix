{ pkgs
, config
, outputs
, ...
}: {
  imports = [
    ../modules/syncthing.nix

    ./modules/kitty.nix
    ./modules/look-and-feel.nix
    ./modules/zathura.nix
  ];

  home = {
    username = "arthur";
    homeDirectory = "/home/arthur";

    # Symlink programs not supported by home-manager, or stuff that I'd rather keep out of it!
    file."${config.xdg.configHome}/hypr" = { source = ./configs/hypr; recursive = true; };
    file."${config.xdg.configHome}/wal" = { source = ./configs/pywal; recursive = true; };
    file."${config.xdg.configHome}/waybar" = { source = ./configs/waybar; recursive = true; };
    file."${config.xdg.configHome}/swaylock" = { source = ./configs/swaylock; recursive = true; };
    file."${config.xdg.configHome}/dunst" = { source = ./configs/dunst; recursive = true; };
    file."${config.xdg.configHome}/ranger" = { source = ./configs/ranger; recursive = true; };

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
  };

  xdg = {
    configFile = {
      "nvim" = {
        enable = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home/arthur/configs/neovim";
        recursive = true;
      };
      "zshrc" = {
        enable = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home/arthur/configs/zsh/zshrc";
        target = "${config.home.homeDirectory}/.zshrc";
      };
      "xinitrc" = {
        enable = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home/arthur/configs/xinitrc";
        target = "${config.home.homeDirectory}/.xinitrc";
      };
      "i3" = {
        enable = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home/arthur/configs/i3";
      };
      "picom" = {
        enable = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home/arthur/configs/picom";
      };
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "applications/pdf" = [ "zathura.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
