let 
  common = import ../modules/common;
  combined = import ../modules/combined;
  home = import ../modules/home;
in {
  nixosModules.default = {
    imports = [
      common.default
      combined.nixosModules.default
    ];
  };

  homeManagerModules.default = {
    imports = [
      common.default
      combined.homeManagerModules.default
      home.default
    ];
  };
}