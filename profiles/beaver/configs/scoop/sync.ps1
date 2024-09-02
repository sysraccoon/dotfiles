scoop bucket add "extras"
scoop bucket add "versions"
scoop bucket add sysraccoon https://github.com/sysraccoon/scoop-bucket

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
    "kanata-winiov2",

    # web
    "firefox",
    "googlechrome",

    # record
    "obs-studio"
)

$not_required_packages = $(scoop list | where { $_.Name -notin $required_packages } | select -ExpandProperty Name)
if ($not_required_packages.count -gt 0) {
    # Remove all unspecified packages
    scoop uninstall $not_required_packages
}

# Install all explicit specified packages
scoop install $required_packages
