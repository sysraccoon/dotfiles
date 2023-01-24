scoop bucket add "extras"
scoop bucket add "versions"

$required_packages = (
    # cli
    "gsudo",
    "gh",
    "git",
    "vim",
    "neovim",
    "ripgrep",
    "fzf",
    "7zip",
    "msklc",
    # core workflow
    "autohotkey1.1",
    # web
    "firefox",
    "googlechrome"
)

$not_required_packages = $(scoop list | where { $_.Name -notin $required_packages } | select -ExpandProperty Name)
if ($not_required_packages.count -gt 0) {
    # Remove all unspecified packages
    scoop uninstall $not_required_packages
}

# Install all explicit specified packages
scoop install $required_packages
