{ confg, pkgs, ... }:

{
  imports = [
  	../gnome/home.nix
  	./packages.nix
  ];


  ### META
  
  home.username = "deirn";
  home.homeDirectory = "/home/deirn";

  # DO NOT TOUCH
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
