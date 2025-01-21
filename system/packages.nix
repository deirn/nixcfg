{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cloudflare-warp
    git
    micro
    wget
    wl-clipboard
  ];

  environment.variables.EDITOR = "micro";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.pathsToLink = [ "/share/zsh" ];

  services.cloudflare-warp.enable = true;

  programs.nix-ld.enable = true;
}
