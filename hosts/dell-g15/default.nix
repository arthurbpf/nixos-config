{ config, inputs, outputs, pkgs, lib, ... }:
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.

      ../common/users/arthur.nix

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
      outputs.nixosModules.sh
      outputs.nixosModules.virtualization
    ];

  # Graphics 
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      nvidia-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
    ];
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      vaapiIntel
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
  nixpkgs.config.cudaSupport = true;

  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  virtualisation.docker.storageDriver = "btrfs";

  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
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

  networking.hostName = "dell-g15";

  services.sshd.enable = true;
  programs.adb.enable = true;

  specialisation = {
    powersaving.configuration = {
      system.nixos.tags = [ "powersaving" ];
      hardware.nvidia = {
        powerManagement.finegrained = lib.mkForce true;

        prime = {
          sync.enable = lib.mkForce false;
          reverseSync.enable = lib.mkForce false;

          offload.enable = lib.mkForce true;
          offload.enableOffloadCmd = lib.mkForce true;
        };
      };
      environment.sessionVariables = {
        # Tell WLR to render using Intel GPU
        WLR_DRM_DEVICES = lib.mkForce "/dev/dri/card1";
      };
    };
    powersaving-with-gpu.configuration = {
      system.nixos.tags = [ "powersaving-with-gpu" ];
      hardware.nvidia = {
        powerManagement.finegrained = lib.mkForce true;

        prime = {
          sync.enable = lib.mkForce false;
          reverseSync.enable = lib.mkForce false;

          offload.enable = lib.mkForce true;
          offload.enableOffloadCmd = lib.mkForce true;
        };
      };
      environment.sessionVariables = {
        # Tell WLR to render using Intel GPU
        WLR_DRM_DEVICES = lib.mkForce "/dev/dri/card1:/dev/dri/card0";
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
