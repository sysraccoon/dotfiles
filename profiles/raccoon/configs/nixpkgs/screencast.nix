{ config, pkgs, lib, ... }:

{
  specialisation.screencast.configuration = {
    home.packages = with pkgs; [
      jql
    ];
  };
}
