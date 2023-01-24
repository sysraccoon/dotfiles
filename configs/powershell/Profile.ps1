Set-PSReadLineOption -EditMode Emacs

function Prompt
{
    "$([char]0x250c)$([char]0x2500)( $(Get-Location) )`r`n$([char]0x2514)$([char]0x2500)$([char]0x25ba) "
}
