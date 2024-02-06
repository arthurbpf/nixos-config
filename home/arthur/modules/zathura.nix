{...}: {
    # Zathura - a lightweight PDF viewer
    programs.zathura = {
      enable = true;
      mappings = {
        m = "page-right-to-left";
      };
      options = {
        selection-clipboard = "clipboard";
      };
    };
}
