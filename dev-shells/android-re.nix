{ pkgs, ... }:
let
  android = {
    versions = {
      tools = "26.1.1";
      platformTools = "33.0.3";
      buildTools = "30.0.3";
      emulator = "31.3.14";
    };
    platforms = [ "27" "29" "34" ];
    abis = [ "x86_64" ];
    systemImageTypes = [ "default" "google_apis" ];
  };
  androidEnv = pkgs.androidenv;
  androidComposition = androidEnv.composeAndroidPackages {
    toolsVersion = android.versions.tools;
    platformToolsVersion = android.versions.platformTools;
    buildToolsVersions = [ android.versions.buildTools ];

    includeSystemImages = true;
    platformVersions = android.platforms;
    abiVersions = android.abis;

    includeEmulator = true;
    emulatorVersion = android.versions.emulator;
    systemImageTypes = android.systemImageTypes;

    useGoogleAPIs = true;

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
  targetPkgs = pkgs: (with pkgs;
    [
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
    export QT_QPA_PLATFORM="wayland;xcb"
  '';
  runScript = "zsh";
}).env