{ my, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initExtraBeforeCompInit = my.mkGlue.init "head";
    initExtra = ''
      ${my.mkGlue.init "tail"}
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${my.nixcfg}/modules/zsh/p10k.zsh
    '';
  };
}
