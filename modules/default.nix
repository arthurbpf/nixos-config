{
  base = import ./base.nix;

  audio = import ./audio.nix;
  battery = import ./battery.nix;
  bluetooth = import ./bluetooth.nix;
  fonts = import ./fonts.nix;
  gaming = import ./gaming.nix;
  graphical_env = import ./graphical_env.nix;
  networking = import ./networking.nix;
  printers = import ./printers.nix;
  programming = import ./programming.nix;
  sh = import ./sh.nix;
  virtualization = import ./virtualization.nix;
}
