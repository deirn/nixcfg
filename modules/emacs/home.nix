{ my, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnumake
    ripgrep
    fd
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;

    extraPackages =
      epkgs: with epkgs; [
        vterm
      ];
  };

  home.file = lib.mkMerge [
    (my.mkConfig "doom" "modules/emacs/doom")
    (my.mkGlue.head.text "10-emacs" (my.mkPathEnv "${my.config}/emacs/bin"))
  ];
}
