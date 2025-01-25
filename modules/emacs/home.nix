{ my, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnumake
    ripgrep
    fd
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;

    extraPackages =
      epkgs: with epkgs; [
        vterm
      ];
  };

  services.emacs = {
    enable = true;
    startWithUserSession = true;
  };

  home.file = lib.mkMerge [
    (my.mkConfig "doom" "modules/emacs/doom")
    (my.mkGlue.head.text "add-emacs-bin-to-path" (my.mkPathEnv "${my.config}/emacs/bin"))
  ];
}
