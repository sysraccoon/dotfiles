{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    binutils
    ((emacsPackagesFor emacsNativeComp).emacsWithPackages
        (epkgs: [ epkgs.vterm ]))

    # DOOM dependencies
    git
    (ripgrep.override {withPCRE2 = true;})
    gnutls

    # Optional dependencies
    fd
    imagemagick
    zstd


    # Module dependencies
    (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
    editorconfig-core-c
    sqlite
    texlive.combined.scheme-full
    beancount
    fava

    # org-roam
    graphviz

    ## Fonts
    emacs-all-the-icons-fonts
  ];
}
