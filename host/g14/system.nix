{ my, inputs, ... }:

{
  imports = with inputs; [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.asus-zephyrus-ga401

    ../../system
    ../../gnome/system.nix
  ] + (my.modules [
    "essentials"
    "gnome"
    "zsh"
  ]);

  networking.hostName = "g14";

  # Disable dynamic boost as it is unavailable here
  hardware.nvidia.dynamicBoost.enable = false;

  ### USERS

  users.users.deirn = {
    isNormalUser = true;
    description = "deirn";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  ### SYSTEM

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  time.hardwareClockInLocalTime = true; # Fix time when dual-booting with windows

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  ### AUDIO

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  ### NETWORKING

  networking.networkmanager = {
    enable = true;
    insertNameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  ### META

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
