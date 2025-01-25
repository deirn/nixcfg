{ pkgs, ... }:

{
  users.defaultUserShell = pkgs.zsh;
  environment.pathsToLink = [ "/share/zsh" ];

  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };
}
