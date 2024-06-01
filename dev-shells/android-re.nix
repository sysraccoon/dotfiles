{pkgs, ...}: let
  android = {
    versions = {
      tools = "26.1.1";
      platformTools = "35.0.1";
      buildTools = "34.0.0";
      emulator = "34.2.11";
    };
    platforms = ["27" "34"];
    abis = ["x86_64"];
    systemImageTypes = ["default"];
  };
  androidEnv = pkgs.androidenv;
  androidComposition = androidEnv.composeAndroidPackages {
    toolsVersion = android.versions.tools;
    platformToolsVersion = android.versions.platformTools;
    buildToolsVersions = [android.versions.buildTools];

    includeSystemImages = true;
    platformVersions = android.platforms;
    abiVersions = android.abis;

    includeEmulator = true;
    emulatorVersion = android.versions.emulator;
    systemImageTypes = android.systemImageTypes;

    useGoogleAPIs = false;

    extraLicenses = [
      "android-sdk-preview-license"
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
  };
  androidSdk = androidComposition.androidsdk;
in
  (pkgs.buildFHSUserEnv
    {
      name = "android-re";
      targetPkgs = pkgs: (
        with pkgs; [
          android-studio
          androidSdk
        ]
      );
      profile = ''
        export JAVA_HOME=$(readlink -e $(type -p javac) | sed  -e 's/\/bin\/javac//g')
        export ANDROID_HOME="${androidSdk}/libexec/android-sdk"
        export ANDROID_SDK_ROOT="${androidSdk}/libexec/android-sdk"
        export ANDROID_USER_HOME="$HOME/.android"
        export ANDROID_AVD_HOME="$HOME/.android/avd"
        export QT_QPA_PLATFORM="xcb"
        export LD_LIBRARY_PATH="${pkgs.libglvnd}/lib"
      '';
      runScript = "zsh";
    })
  .env
