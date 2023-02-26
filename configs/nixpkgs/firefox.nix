{ config, lib, pkgs, ... }:

let 
  firefoxProfile = { id, name, settings ? {}, default ? false }:
  {
    id = id;
    name = name;
    isDefault = default;
    settings = {
      "app.update.auto" = false;
      "signon.rememberSignons" = false;
      "browser.startup.homepage" = "about:blank";
      "browser.newtabpage.enabled" = false;
      "browser.toolbars.bookmarks.visibility" = "never";
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "dom.textMetrics.fontBoundingBox.enabled" = true;
    } // settings;
    userChrome = builtins.readFile ../firefox/chrome/userChrome.css;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      vimium
      kristofferhagen-nord-theme
    ];
  };
in
{
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  programs.firefox = {
    enable = true;
    profiles = {
      main = firefoxProfile {
        id = 0;
        name = "main";
        default = true;
      };
      screencast = firefoxProfile {
        id = 1;
        name = "screencast";
        settings = {
          "layout.css.devPixelsPerPx" = 1.5;
        };
      };
    };
  };
}
