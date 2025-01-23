{ config, lib, ... }:

let
  my._root = ../.;
  my.modules = modules: map (module : my._root + "/modules/${module}/system.nix") modules;
in
my
