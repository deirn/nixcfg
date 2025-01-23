{ pkgs, ... }:

let
  extensions = with pkgs.gnomeExtensions; [
    cloudflare-warp-toggle
    pano
    pop-shell
    status-area-horizontal-spacing
    tray-icons-reloaded
  ];
in
{
  home.packages =
    extensions
    ++ (with pkgs; [
      dconf-editor
    ]);

  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = map (x: x.extensionUuid) extensions;
    };

    "org/gnome/shell/extensions/pano" = {
      play-audio-on-copy = false;
      send-notification-on-copy = false;
    };

    "org/gnome/shell/extensions/status-area-horizontal-spacing" = {
      hpadding = 3;
    };
  };
}
