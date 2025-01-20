{ ... }:

{
  imports = [
    ./packages.nix
    ./users.nix
  ];

  ### META

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Add wheel to trusted users
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

  ### SYSTEM

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Asia/Jakarta";
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
}