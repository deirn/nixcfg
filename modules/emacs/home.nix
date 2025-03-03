{ my, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnumake
    ripgrep
    fd
    emacs-lsp-booster
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs30;

    extraPackages =
      epkgs: with epkgs; [
        vterm
      ];
  };

  home.file = lib.mkMerge [
    (my.mkConfig "doom" "modules/emacs/doom")
    (my.mkGlue.head.text "add-emacs-bin-to-path" (my.mkPathEnv "${my.config}/emacs/bin"))
  ];
}
