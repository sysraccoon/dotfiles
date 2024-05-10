#!/usr/bin/env bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([out], o, [Output path], [out])
# ARG_POSITIONAL_SINGLE([apk], [Path to target APK], )
# ARG_DEFAULTS_POS
# ARG_HELP([<The general help message of my script>])
# ARGBASH_GO

# [ <-- needed because of Argbash

if ! check-dependencies \
  codium apktool jadx ; then
  exit 1
fi

if ! [ -f $_arg_apk ]; then
    echo "FATAL ERROR: APK file not exists"
    exit 1
fi

apktool --output "${_arg_out}" d "${_arg_apk}"
jadx --no-res --output-dir "${_arg_out}/java" "${_arg_apk}"
cp "${_arg_apk}" "${_arg_out}"
codium "${_arg_out}"

# ] <-- needed because of Argbash
