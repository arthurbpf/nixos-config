{ pkgs
, config
, ...
}: {
  imports = [
  ];

  home = {
    username = "server";
    homeDirectory = "/home/server";

    # Symlink programs not supported by home-manager, or stuff that I'd rather keep out of it!
    # file."${config.home.homeDirectory}/" = { source = ./dotfiles; recursive = true; };
    file."${config.xdg.configHome}/nvim" = { source = ../arthur/configs/neovim; recursive = true; };
    file."${config.xdg.configHome}/ranger" = { source = ../arthur/configs/ranger; recursive = true; };

    # User specific packages
    packages = with pkgs; [
    ];

    stateVersion = "23.11";
  };

  programs = {
    git.enable = true;

    # SSH
    ssh = {
      enable = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
