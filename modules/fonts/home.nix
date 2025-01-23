{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    dejavu_fonts
    jetbrains-mono
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "NerdFontsSymbolsOnly"
      ];
    })
  ];
}
