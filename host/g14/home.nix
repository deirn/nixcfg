{ my, config, lib, pkgs, ... }:

{
  imports = my.modules [
    "essentials"
    "devenv"
    "emacs"
    "fetch"
    "fonts"
    "git"
    "gnome"
    "python"
    "zsh"
  ];
}
