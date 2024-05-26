# SHORT:
# This overlay apply patch to fix udevmon inside interception-tools package
# EXPLANATION:
# If you try run udevmon with configuration:
# - JOB: "intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE"
#   DEVICE:
#     EVENTS:
#       EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
# You get bunch of errors like this:
# > sh: line 1: intercept: command not found
# > sh: line 1: caps2esc: command not found
# > sh: line 1: uinput: command not found
# In current implementation udevmon call execvpe with "sh -c"
# but don't pass PATH to envs.
{
  overlay = final: prev: {
    interception-tools = prev.interception-tools.overrideAttrs (oldAttrs: rec {
      patches = let
        oldPatches = oldAttrs.patches or [];
      in
        (
          if oldPatches == null
          then []
          else oldPatches
        )
        ++ [
          ./udevmon-path-fix.patch
        ];
    });
  };
}
