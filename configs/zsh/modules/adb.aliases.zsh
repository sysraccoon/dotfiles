alias adb-ip="adb shell ip -4 -o a | cut -d ' ' -f 2,7 | cut -d '/' -f 1"
alias extract-ip="cut -d ' ' -f 2"

function adb-ip-grep() {
  adb-ip | grep $1 | extract-ip
}

export ANDROID_SERIAL="$(cat /tmp/android_serial 2>/dev/null)"

alias adb-fzf-ip="adb-ip | fzf | extract-ip"
alias adb-fzf-app='adb shell pm list packages | cut -c 9- | fzf'
alias adb-fzf-prune='adb-fzf-app | xargs --no-run-if-empty adb-prune-app'
alias adb-fzf-device="adb devices -l | awk 'NR>1 && NF' | fzf | awk '{ print \$1 }'"
alias adb-select-device='export ANDROID_SERIAL=$(adb-fzf-device)'
alias adb-select-device-global='export ANDROID_SERIAL=$(adb-fzf-device); echo "$ANDROID_SERIAL" > /tmp/android_serial'
alias adb-reset-device-global='rm --force /tmp/android_serial && export ANDROID_SERIAL=""'

function adb-type {
  adb shell "input text '$@' && input keyevent 66"
}

