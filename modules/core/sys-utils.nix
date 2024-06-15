{
  lib,
  config,
  pkgs,
  ...
}: {
  config._module.args.sysUtils = {
    # source: https://www.reddit.com/r/NixOS/comments/scf0ui/comment/j3dfk27/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    patchDesktop = {
      pkg,
      appName,
      from,
      to,
      ...
    }:
      with pkgs; let
        zipped = lib.zipLists from to;
        # Multiple operations to be performed by sed are specified with -e
        sed-args =
          builtins.map
          ({
            fst,
            snd,
          }: "-e 's#${fst}#${snd}#g'")
          zipped;
        concat-args = builtins.concatStringsSep " " sed-args;
      in
        lib.hiPrio
        (pkgs.runCommand "$patched-desktop-entry-for-${appName}" {} ''
          ${coreutils}/bin/mkdir -p $out/share/applications
          ${gnused}/bin/sed ${concat-args} \
          ${pkg}/share/applications/${appName}.desktop \
          > $out/share/applications/${appName}.desktop
        '');
  };
}
