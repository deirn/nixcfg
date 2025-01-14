{ confg, pkgs, ... }:

{
  home.username = "deirn";
  home.homeDirectory = "/home/deirn";

  home.packages = with pkgs; [
    floorp
  	vesktop
  ];

  programs.git = {
  	enable = true;
  	userName = "deirn";
  	userEmail = "deirn@bai.lol";

#   	extraConfig = {
#   	  credential.helper = "${
#   	    pkgs.git.override { withLibsecret = true; }
#   	  }/bin/git-credential-libsecret";
# 
#   	  commit.gpgsign = true;
#   	};
  };

  # DO NOT TOUCH
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
