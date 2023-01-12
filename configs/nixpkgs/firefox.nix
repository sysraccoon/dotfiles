{ config, pkgs, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
  programs.firefox = {
    enable = true;
    profiles = {
      main = {
        id = 0;
        settings = {
          "app.update.auto" = false;
          "signon.rememberSignons" = false;
          "browser.startup.homepage" = "about:blank";
          "browser.newtabpage.enabled" = false;
          "browser.toolbars.bookmarks.visibility" = "never";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
        userChrome = builtins.readFile ../firefox/chrome/userChrome.css;
      };
    };
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      vimium
      kristofferhagen-nord-theme
    ];
  };
}
