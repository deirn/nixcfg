{ my, config, lib, pkgs, ... }:

{
  home.username = "deirn";
  home.homeDirectory = "/home/deirn";

  home.packages = with pkgs; [
    glib
  ];

  # DO NOT TOUCH
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
