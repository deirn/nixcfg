{ my, lib, pkgs, ... }:

let
  my2.jdks = with pkgs; {
    "21" = jdk;
    "17" = jdk17;
  };

  my2.jdkHomes = lib.mapAttrs (k: v: "${v}/lib/openjdk") my2.jdks;
  my2.jdkFiles = lib.mapAttrs' (k: v: lib.nameValuePair ".jdk/${k}" { source = v; }) my2.jdkHomes;
  my2.jdkPaths = lib.concatStringsSep "," (lib.mapAttrsToList (k: v: v) my2.jdkHomes);
  my2.jdkEmacs = lib.concatStringsSep ")\n  (" (
    lib.mapAttrsToList (k: v: ":name \"JavaSE-${k}\" :path \"${v}\"") my2.jdkHomes
  );
in
{
  home.packages = with pkgs; [
    jdk # 21
  ];

  # Symlink multiple Java version to ~/.jdk
  home.file = lib.mkMerge [
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
