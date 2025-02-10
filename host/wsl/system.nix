# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

args@{
  config,
  lib,
  pkgs,
  ...
}:

let
  my = import ../../lib/system.nix args;
in

{
  imports = my.modules [
    "essentials"
    "cachix"
    "zsh"
  ];

  networking.hostName = "wsl";

  wsl = {
    enable = true;
    defaultUser = "deirn";
    useWindowsDriver = true;
    # Enable Windows shortcut for GUI application
    # startMenuLaunchers = true;
    # Disable addition of Windows PATH
    # interop.includePath = false;
  };

  security.sudo.wheelNeedsPassword = true;

  # Fix hardware acceleration
  # https://github.com/nix-community/NixOS-WSL/issues/454
  environment.sessionVariables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
    EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
    EXTRA_CCFLAGS = "-I/usr/include";
    LD_LIBRARY_PATH =  [
      "/usr/lib/wsl/lib"
      "${pkgs.linuxPackages.nvidia_x11}/lib"
      "${pkgs.ncurses5}/lib"
  	  "/run/opengl-driver/lib"
    ];
    MESA_D3D12_DEFAULT_ADAPTER_NAME = "Nvidia";
  };

  services.xserver.displayManager.xpra.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
