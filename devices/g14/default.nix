{ inputs, ... }:

{
  imports = with inputs; [
  	./hardware-configuration.nix
  	nixos-hardware.nixosModules.asus-zephyrus-ga401

  	../common
  	../../gnome/system.nix
  ];

  networking.hostName = "g14";

  # Disable dynamic boost as it is unavailable here
  hardware.nvidia.dynamicBoost.enable = false;


  ### META

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
