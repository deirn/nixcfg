{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  my.home = config.home.homeDirectory;
  my.config = config.xdg.configHome;
  my.self = "${my.home}/.nixos-config/home";

  # https://github.com/nix-community/home-manager/issues/676
  my.mkLink = path: { source = config.lib.file.mkOutOfStoreSymlink "${my.self}/${path}"; };
in
lib.mkMerge [
  {
    home.packages = with pkgs; [
      devenv
      fastfetch
      floorp
      gnumake
      nodejs_22
      obsidian
      python313
      vesktop
      vlc
    ];
  }
  {
    ### ZSH
    programs.zsh = {
      enable = true;
      enableCompletion = true;

      initExtraBeforeCompInit = ''
        source ${my.self}/zsh/before_comp.zsh
      '';

      initExtra = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${my.self}/zsh/p10k.zsh
      '';
    };
  }
  {
    ### FONTS
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      jetbrains-mono
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "NerdFontsSymbolsOnly"
        ];
      })
    ];
  }
  {
    ### EMACS
    home.packages = with pkgs; [
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

    home.file."${my.config}/doom" = my.mkLink "doom";
  }
  {
    ### GIT
    programs.git = {
      enable = true;
      userName = "Dimas Firmansyah";
      userEmail = "deirn@bai.lol";

      signing = {
        signByDefault = true;
        key = null;
      };

      extraConfig = {
        credential = {
          helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
          credentialStore = "secretservice";
        };
      };
    };

    programs.gpg.enable = true;
    services.gpg-agent.enable = true;
  }
  {
    ### JAVA
    home.packages = with pkgs; [
      jdk # 21
    ];

    # Symlink multiple Java version to ~/.jdk
    home.file =
      with pkgs;
      let
        my.jdks = {
          "21" = jdk;
          "17" = jdk17;
        };

        my.fn = k: v: lib.nameValuePair ".jdk/${k}" { source = "${v}/lib/openjdk"; };
      in
      lib.mapAttrs' my.fn my.jdks;
  }
]
