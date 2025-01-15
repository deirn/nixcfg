{ pkgs, ... }:

let
  extensions = import ./extensions.nix { inherit pkgs; };
in
{
  dconf.enable = true;
  dconf.settings = {
  	"org/gnome/shell" = {
  	  disable-user-extensions = false;
  	  enabled-extensions = map (x: x.extensionUuid) extensions;
  	};

  	"org/gnome/shell/extensions/status-area-horizontal-spacing" = {
  	  hpadding = 3;
  	};
  };
}
