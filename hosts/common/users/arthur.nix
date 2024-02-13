{ pkgs, inputs, ... }: {

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arthur = {
    isNormalUser = true;
    description = "Arthur";
    extraGroups = [ "video" "audio" "networkmanager" "wheel" "input" "adbusers" "docker" ];
    shell = pkgs.zsh;
    packages = [
      inputs.home-manager.packages.${pkgs.system}.home-manager
    ];
  };

  home-manager.users.arthur = import ./../../../home/arthur/default.nix;
}
