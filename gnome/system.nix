{ pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
  	epiphany          # web browser
  	geary             # email client
  	gnome-calculator
  	gnome-calendar
  	gnome-clocks
  	gnome-connections # remote desktop
  	# gnome-console
  	gnome-contacts
  	gnome-maps
  	gnome-text-editor
  	gnome-tour
  	gnome-weather
  	snapshot          # camera
  	simple-scan       # scanner
  	totem             # video player
  ];
}
