{ confg, pkgs, ... }:

{
  imports = [
  	../gnome/home.nix
  ];


  ### META
  
  home.username = "deirn";
  home.homeDirectory = "/home/deirn";

  home.packages = with pkgs; [
    alacritty
    floorp
  	vesktop
  	vlc
  ];

  programs.bash.enable = true;

  programs.git = {
  	enable = true;
  	userName = "deirn";
  	userEmail = "deirn@bai.lol";
  };

  # DO NOT TOUCH
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
