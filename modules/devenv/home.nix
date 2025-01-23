{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    devenv
  ];

  programs.direnv.enable = true;
}
