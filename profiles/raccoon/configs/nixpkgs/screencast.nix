{ config, pkgs, lib, ... }:

{
  specialisation.screencast.configuration = {
    home.sessionVariables = {
      SCREENCAST_MODE = "1";
    };

    programs.firefox = {
      profiles = {
        main = {
          isDefault = lib.mkForce false;
        };
        screencast = {
          isDefault = lib.mkForce true;
        };
      };
    };

    home.packages = with pkgs; [
      jql
    ];
  };
}
