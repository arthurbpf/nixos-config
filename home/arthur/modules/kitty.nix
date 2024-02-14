{ ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_family = "monospace";
      font_size = 10;

      window_padding_width = 5;

      background_opacity = "0.9";
      background_blur = 1;
    };

    shellIntegration = {
      enableZshIntegration = true;
    };

    theme = "Catppuccin-Mocha";
  };
}
