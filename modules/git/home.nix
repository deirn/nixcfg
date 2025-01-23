{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Dimas Firmansyah";
    userEmail = "deirn@bai.lol";

    signing = {
      signByDefault = true;
      key = null;
    };

    #       extraConfig = {
    #         credential = {
    #           helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
    #           credentialStore = "secretservice";
    #         };
    #       };
  };
  #
  #     programs.gpg.enable = true;
  #     services.gpg-agent.enable = true;

  # GitHub CLI
  programs.gh.enable = true;
}
