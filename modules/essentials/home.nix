{ my, config, lib, pkgs, ... }:

{
  home.username = "deirn";
  home.homeDirectory = "/home/deirn";

  home.packages = with pkgs; [
    glib
  ];

  home.file = lib.mkMerge [
    (my.mkGlue.head.text "add-cfg-bin-to-path" (my.mkPathEnv "${my.nixcfg}/bin"))
  ];

  # DO NOT TOUCH
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
