{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  git-hooks.hooks.format = {
    enable = true;
    entry = "nix fmt";
  };
}
