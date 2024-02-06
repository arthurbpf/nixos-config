{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "arthur";
    homeDirectory = "/home/arthur";

    # Deploy dotfiles submodule to home
    file."/home/arthur/" = {
    	source = ./dotfiles;
	recursive = true;
    };

    stateVersion = "23.11";
  };

  # User specific packages
  home.packages = with pkgs; [
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

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # SSH
  programs.ssh = {
    enable = true;
    extraConfig = "
Host github.com
    User git
    IdentityFile ~/.ssh/github
";
  };

  # Zathura - a lightweight PDF viewer
  programs.zathura = {
    enable = true;
    mappings = {
        m = "page-right-to-left";
    };
    options = {
        selection-clipboard = "clipboard";
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
