{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  my.home = config.home.homeDirectory;
  my.config = config.xdg.configHome;
  my.self = "${my.home}/.nixos-config/home";

  # https://github.com/nix-community/home-manager/issues/676
  my.mkLink = path: { source = config.lib.file.mkOutOfStoreSymlink "${my.self}/${path}"; };

  my.mkConfig = name: { "${my.config}/${name}" = my.mkLink name; };
  my.mkConfigs = names: mkMerge (map my.mkConfig names);
in
mkMerge [
  {
    home.packages = with pkgs; [
      devenv
      fastfetch
      floorp
      gnumake
      nodejs_22
      obsidian
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

    home.file = my.mkConfig "doom";
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

        my.jdkHomes = mapAttrs (k: v: "${v}/lib/openjdk") my.jdks;
        my.jdkFiles = mapAttrs' (k: v: nameValuePair ".jdk/${k}" { source = v; }) my.jdkHomes;
        my.jdkPaths = concatStringsSep "," (mapAttrsToList (k: v: v) my.jdkHomes);
        my.jdkEmacs = concatStringsSep ")\n  (" (
          mapAttrsToList (k: v: ":name \"JavaSE-${k}\" :path \"${v}\"") my.jdkHomes
        );
      in
      mkMerge [
        my.jdkFiles
        {
          ".gradle/gradle.properties".text = ''
            org.gradle.java.installations.paths=${my.jdkPaths}
          '';
          ".jdk/doom.el".text = ''
            (setq lsp-java-configuration-runtimes '[
              (${my.jdkEmacs})
            ])
          '';
        }
      ];
  }
  {
    ### PYTHON
    home.packages = with pkgs; [
      python313
      pipx
    ];
  }
]
