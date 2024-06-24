{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      # Keep logs, useful if something went wrong (but sometimes need manualy clean up)
      "/var/log"
      # Some information about users and groups stored here
      "/var/lib/nixos"
      # Save microvm.nix setup
      "/var/lib/microvms"
      # Keep wifi connection information
      "/var/lib/NetworkManager"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      # Used by systemd for the journal
      "/etc/machine-id"
    ];
  };

  users.mutableUsers = false;
  fileSystems."/nix".neededForBoot = true;
  users.users = let
    mainUser = config.sys.nixos.mainUser.username;
  in {
    # If you want generate password for new user or change old use this:
    # sudo mkpasswd -m sha-512 > /nix/persist/passwords/user
    root.hashedPasswordFile = "/nix/persist/passwords/root";
    ${mainUser}.hashedPasswordFile = "/nix/persist/passwords/${mainUser}";
  };

  # No need to lecture me after every reboot
  security.sudo.extraConfig = ''
    Defaults  lecture="never"
  '';
}
