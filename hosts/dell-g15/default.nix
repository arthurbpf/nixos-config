# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, outputs, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.

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
      outputs.nixosModules.sh
      outputs.nixosModules.virtualization
    ];

  # Graphics 
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
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

    # PRIME Configuration
    prime = {
      sync.enable = true;

      # Note that bus values change according to each system, get them with lshw -c display!!!
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  virtualisation.docker.enableNvidia = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.cudaSupport = true;

  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arthur = {
    isNormalUser = true;
    description = "Arthur";
    extraGroups = [ "networkmanager" "wheel" "input" "adbusers" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  networking.hostName = "dell-g15";

  services.syncthing = {
    enable = true;
    user = "arthur";
    dataDir = "/home/arthur/Sync"; # Default folder for new synced folders
    configDir = "/home/arthur/.config/syncthing"; # Folder for Syncthing's settings and keys
  };
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
