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

    open = false;

    nvidiaSettings = true;
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

    loader = {
      efi = {
        canTouchEfiVariables = true;
      };

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 10;
      };
    };
  };

  time.hardwareClockInLocalTime = true;
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

  specialisation = {
    powersaving-no-dgpu.configuration = {
      system.nixos.tags = [ "powersaving-no-dgpu" ];

      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';
        
      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
      boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];

      hardware.nvidia = {
        modesetting.enable = lib.mkForce false;
        powerManagement.enable = lib.mkForce false;
        powerManagement.finegrained = lib.mkForce false;

        prime = {
          sync.enable = lib.mkForce false;
          reverseSync.enable = lib.mkForce false;
          offload.enable = lib.mkForce false;
          offload.enableOffloadCmd = lib.mkForce false;
        };
      };
    };

    powersaving-with-dgpu.configuration = {
      system.nixos.tags = [ "powersaving-with-dgpu" ];

      hardware.nvidia = {
        powerManagement.finegrained = lib.mkForce true;

        prime = {
          sync.enable = lib.mkForce false;
          reverseSync.enable = lib.mkForce false;

          offload.enable = lib.mkForce true;
          offload.enableOffloadCmd = lib.mkForce true;
        };
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
