{ pkgs, inputs, ... }: {

  users.users.server = {
    isNormalUser = true;
    description = "Server";
    extraGroups = [ "networkmanager" "wheel" "input" "docker" "cloudflared" "terraria" ];
    shell = pkgs.bash;
    packages = [
      inputs.home-manager.packages.${pkgs.system}.home-manager
    ];
  };

  home-manager.users.server = import ./../../../home/server/default.nix;
}
