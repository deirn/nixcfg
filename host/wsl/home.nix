args@{ config, lib, pkgs, ... }:

let
  my = import ../../lib/home.nix args;
in
{
  imports = my.modules [
    "essentials"
    "bash"
    "devenv"
    "emacs"
    "fetch"
    "fonts"
    "git"
    "nodejs"
    "python"
    "zsh"
  ];

  home.packages = with pkgs; [
    sensible-utils
    socat
    xdg-utils
    wsl-open
  ];

  home.file = lib.mkMerge [
    (my.mkGlue.head.text "use-wsl-open" ''
      export BROWSER="wsl-open"
    '')
  ];

  programs.git.signing.gpgPath = "/mnt/c/Program Files (x86)/GnuPG/bin/gpg.exe";

  # systemd.user.services = lib.mkMerge [
  #   (my.mkService "discord-ipc-relay" "Relay Discord rich presence IPC to Windows host" ''
  #     RELAY="/mnt/c/Users/deirn/AppData/Local/Microsoft/WinGet/Links/npiperelay.exe"
  #     if [ ! -f "$RELAY" ]; then
  #       echo "npiperelay.exe not found"
  #       exit 1
  #     fi

  #     ${pkgs.socat}/bin/socat UNIX-LISTEN:/tmp/discord-ipc-0,fork EXEC:"$RELAY -ep -s //./pipe/discord-ipc-0",nofork
  #   '')
  # ];
}
