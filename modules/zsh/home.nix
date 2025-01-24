{ my, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initExtraBeforeCompInit = my.mkGlue.init "head";
    initExtra = my.mkGlue.init "tail";
  };

  home.file = lib.mkMerge [
    (my.mkGlue.tail.source "install-powerlevel10k" "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme")
    (my.mkGlue.tail.link "powerlevel10k-configurations" "modules/zsh/p10k.zsh")
  ];
}
