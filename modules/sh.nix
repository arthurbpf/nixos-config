{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    unstable.neovim
    nodePackages."vscode-langservers-extracted"

    wget
    htop
    ncdu
    bat
    ripgrep
    fzf
    lshw
    git
    gnupg
    trash-cli
    neofetch
    pfetch
    nvtop
    ranger
    viewnior
    eza
    zoxide
    unar
    croc
    tesseract
    yt-dlp
    youtube-dl
    gallery-dl
    awscli2
  ];

  programs.zsh = {
    enable = true;
  };

  users.defaultUserShell = pkgs.bash;
}
