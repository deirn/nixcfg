{ pkgs, ... }:

with pkgs.gnomeExtensions; [
  appindicator
  pop-shell
  status-area-horizontal-spacing
]
