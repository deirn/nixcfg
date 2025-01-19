{ inputs, config, lib, pkgs, ... }:

let
  my.home = config.home.homeDirectory;
  my.config = config.xdg.configHome;
  my.self = "${my.home}/.nixos-config/home";

  # https://github.com/nix-community/home-manager/issues/676
  my.mkLink = path: 
    config.lib.file.mkOutOfStoreSymlink "${my.self}/${path}";
in
lib.mkMerge [{ 
  home.packages = with pkgs; [
    floorp
    gnumake
    obsidian
    python313
    vesktop
    vlc
  ];
}

{ ### ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtraBeforeCompInit = "source ${my.self}/zsh/before_comp_init.zsh";
  };
}

{ ### FONTS
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    jetbrains-mono
    (nerdfonts.override { fonts = [
      "JetBrainsMono"
      "NerdFontsSymbolsOnly"
    ]; })
  ];
}

{ ### EMACS
  home.packages = with pkgs; [
    ripgrep
    fd
  ];
  
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  home.file."${my.config}/doom".source = my.mkLink "doom";
}

{ ### GIT
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
}]
