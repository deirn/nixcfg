args@{ config, lib, pkgs, ... }:

let
  my = import ../../lib/home.nix args;
in
{
  imports = my.modules [
    "essentials"
    "devenv"
    "emacs"
    "fetch"
    "fonts"
    "git"
    "python"
    "zsh"
  ];

  programs.git.signing.gpgPath = "/mnt/c/Program Files (x86)/GnuPG/bin/gpg.exe";
}
