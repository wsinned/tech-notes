{
  programs.kitty = {
    enable = true;
    environment = {
      "MESA_GL_VERSION_OVERRIDE" = "3.3";
    };
    font.name = "MesloLGS NF";
    font.size = 14;
    shellIntegration.enableZshIntegration = true;
  };
}