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

  my.glue = {
    mk =
      stage: name: fn:
      fn "${my.config}/sh-glue/${stage}/${name}.sh";
    mk' = stage: {
      text =
        name: text:
        my.glue.mk stage name (x: {
          "${x}".text = text;
        });
      source =
        name: source:
        my.glue.mk stage name (x: {
          "${x}".source = source;
        });
      link =
        name: link:
        my.glue.mk stage name (x: {
          "${x}" = my.mkLink link;
        });
    };

    head = my.glue.mk' "head";
    tail = my.glue.mk' "tail";

    mkPath = path: ''PATH="$PATH:${path}"'';
  };
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

    programs.direnv.enable = true;
  }
  (
    ### ZSH
    let
      my2.mkGlueSh = stage: ''
        for f in ${my.config}/sh-glue/${stage}/*; do
            source $f
        done
      '';
    in
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;

        initExtraBeforeCompInit = my2.mkGlueSh "head";
        initExtra = my2.mkGlueSh "tail";
      };

      home.file = mkMerge [
        (my.glue.tail.source "10-p10k-install" "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme")
        (my.glue.tail.link "20-p10k-config" "zsh/p10k.zsh")
      ];
    }
  )
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

    home.file = mkMerge [
      (my.mkConfig "doom")
      (my.glue.head.text "10-emacs" (my.glue.mkPath "${my.config}/emacs/bin"))
    ];
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
        my2.jdks = {
          "21" = jdk;
          "17" = jdk17;
        };

        my2.jdkHomes = mapAttrs (k: v: "${v}/lib/openjdk") my2.jdks;
        my2.jdkFiles = mapAttrs' (k: v: nameValuePair ".jdk/${k}" { source = v; }) my2.jdkHomes;
        my2.jdkPaths = concatStringsSep "," (mapAttrsToList (k: v: v) my2.jdkHomes);
        my2.jdkEmacs = concatStringsSep ")\n  (" (
          mapAttrsToList (k: v: ":name \"JavaSE-${k}\" :path \"${v}\"") my2.jdkHomes
        );
      in
      mkMerge [
        my2.jdkFiles
        (my.glue.head.text "10-java" ''JAVA_HOME="${my.home}/.jdk/21"'')
        {
          ".gradle/gradle.properties".text = ''
            org.gradle.java.installations.paths=${my2.jdkPaths}
          '';
          ".jdk/doom.el".text = ''
            (setq lsp-java-configuration-runtimes '[
              (${my2.jdkEmacs})
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
