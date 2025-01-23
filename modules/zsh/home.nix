{ my, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initExtraBeforeCompInit = my.mkGlue.init "head";
    initExtra = my.mkGlue.init "tail";
  };

  home.file = lib.mkMerge [
    (my.mkGlue.tail.source "10-p10k-install" "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme")
    (my.mkGlue.tail.link "20-p10k-config" "modules/zsh/p10k.zsh")
  ];
}
