{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gh
    commitizen

    bun
    nodejs
    corepack
    nodePackages."@nestjs/cli"

    gcc

    cargo
    rustc

    (unstable.ollama.override { acceleration = "cuda"; })

    insomnia
    postman
    mysql-workbench
    dbeaver
    vscode
  ];

  programs.adb.enable = true;
  programs.java.enable = true;
  programs.direnv.enable = true;

  boot.kernel.sysctl = {
    "fs.inotify.max_user_instances" = 4096;
    "fs.inotify.max_user_watches" = 524288;
  };
}
