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

    unstable.ollama

    insomnia
    mysql-workbench
    dbeaver
    vscode
  ];

  programs.adb.enable = true;
}
