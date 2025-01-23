{ my, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    micro
    wget
  ];

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
    EDITOR = "micro";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
  };

  environment.localBinInPath = true;

  programs.nix-ld.enable = true;
}
