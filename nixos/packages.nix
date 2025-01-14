{pkgs, ...}:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    micro
    wget
    wl-clipboard
  ];

  environment.variables.EDITOR = "micro";
}