{ config, inputs, outputs, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.

      ../common/users/arthur.nix
      ../common/users/server.nix

      inputs.home-manager.nixosModules.home-manager

      outputs.nixosModules.base

      outputs.nixosModules.audio
      outputs.nixosModules.battery
      outputs.nixosModules.bluetooth
      outputs.nixosModules.fonts
      outputs.nixosModules.gaming
      outputs.nixosModules.graphical_env
      outputs.nixosModules.networking
      outputs.nixosModules.printers
      outputs.nixosModules.programming
      outputs.nixosModules.server
      outputs.nixosModules.sh
      outputs.nixosModules.virtualization
    ];

  # Graphics 
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  ## NVIDIA
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  virtualisation.docker.enableNvidia = true;
  nixpkgs.config.cudaSupport = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    __GL_GSYNC_ALLOWED = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  virtualisation.docker.storageDriver = "btrfs";

  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" "i2c-piix4" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  networking.hostName = "server";

  services.sshd.enable = true;
  programs.adb.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
