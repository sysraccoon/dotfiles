{ config, lib, pkgs, pkgs-nur, ... }:

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
      "browser.tabs.tabmanager.enabled" = false;
      "browser.download.autohideButton" = false;
      "layout.css.devPixelsPerPx" = 1.0;
    } // settings;
    userChrome = builtins.readFile ../firefox/chrome/userChrome.css;
    extensions = with pkgs-nur.repos.rycee.firefox-addons; [
      ublock-origin
      vimium
      kristofferhagen-nord-theme
    ];
  };
in
{
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

  xdg.mimeApps = {
    defaultApplications = {
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };
  };
}
