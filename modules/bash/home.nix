{ my, config, lib, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      ${my.mkGlue.init "head"}
      ${my.mkGlue.init "tail"}
    '';
  };
}
