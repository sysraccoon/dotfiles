{ pkgs, ... }:
let
  fhs = pkgs.buildFHSUserEnv {
    name = "aosp-dev";
    targetPkgs = pkgs: with pkgs;
      [ git
        gitRepo
        gnupg
        curl
        procps
        openssl
        gnumake
        nettools
        androidenv.androidPkgs_9_0.platform-tools
        jdk
        schedtool
        util-linux
        m4
        gperf
        perl
        libxml2
        zip
        unzip
        bison
        flex
        lzop
        python3
      ];
    multiPkgs = pkgs: with pkgs;
      [ zlib
        ncurses5
      ];
    runScript = "zsh";
    profile = ''
      export ALLOW_NINJA_ENV=true
      export USE_CCACHE=1
      export ANDROID_JAVA_HOME=${pkgs.jdk.home}sdkmanager install avd
      export LD_LIBRARY_PATH=/usr/lib:/usr/lib32
    '';
  };
in fhs.env
