alias extract-ip="cut -d ' ' -f 2"
alias local-ip="ip -4 -o a | cut -d ' ' -f 2,7 | cut -d '/' -f 1"
alias default-network-device="route | grep '^default' | grep -o '[^ ]*$'"

function local-ip-grep() {
  local-ip | grep $1 | extract-ip
}

alias local-ip-default='local-ip-grep $(default-network-device)'

# alias wifi-list='wpa_cli -i $(default-network-device) list_networks'
alias wifi-rescan='nmcli device wifi rescan'
alias wifi-connect='nmcli device wifi connect'

