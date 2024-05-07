{ config, lib, pkgs, impurity, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # general
      {
        name = "vim";
        publisher = "vscodevim";
        version = "1.25.2";
        sha256 = "sha256-hy2Ks6oRc9io6vfgql9aFGjUiRzBCS4mGdDO3NqIFEg=";
      }
      {
        name = "vscode-theme-onedark";
        publisher = "akamud";
        version = "2.3.0";
        sha256 = "sha256-8GGv4L4poTYjdkDwZxgNYajuEmIB5XF1mhJMxO2Ho84=";
      }
      {
        name = "horizon-theme-vscode";
        publisher = "jolaleye";
        version = "2.0.2";
        sha256 = "sha256-bPpcPudftgDXNm60HL1d6vkzDEmi0CqS7Mj2b2CqCLI=";
      }

      # python
      {
        name = "python";
        publisher = "ms-python";
        version = "2023.4.0";
        sha256 = "sha256-owQmPlTgcX6NmtfRrd9i8DMflP65smAmsedPYqV/Gzg=";
      }
      {
        name = "isort";
        publisher = "ms-python";
        version = "2022.8.0";
        sha256 = "sha256-l7mXTKdAE56DdnSaY1cs7sajhG6Yzz0XlZLtHY2saB0=";
      }

      # js/ts
      {
        name = "vscode-typescript-next";
        publisher = "ms-vscode";
        version = "5.1.20230227";
        sha256 = "sha256-hvWmGf6UCwVsHwG+Wj89KtYw+JQu5J6WRrpGakvomM8=";
      }
      {
        name = "es7-react-js-snippets";
        publisher = "dsznajder";
        version = "4.4.3";
        sha256 = "sha256-QF950JhvVIathAygva3wwUOzBLjBm7HE3Sgcp7f20Pc=";
      }

      # rust
      {
        name = "rust-analyzer";
        publisher = "rust-lang";
        version = "0.4.1422";
        sha256 = "sha256-p3Ww/DDG8pqyk0h0FzLrMPa7bzeW5ZJqwr4tS96codk=";
      }
      {
        name = "even-better-toml";
        publisher = "tamasfe";
        version = "0.19.0";
        sha256 = "sha256-MqSQarNThbEf1wHDTf1yA46JMhWJN46b08c7tV6+1nU=";
      }

      # haskell
      {
        name = "haskell";
        publisher = "haskell";
        version = "2.2.2";
        sha256 = "sha256-zWdIVdz+kZg7KZQ7LeBCB4aB9wg8dUbkWfzGlM0Fq7Q=";
      }
      {
        name = "language-haskell";
        publisher = "justusadam";
        version = "3.6.0";
        sha256 = "sha256-rZXRzPmu7IYmyRWANtpJp3wp0r/RwB7eGHEJa7hBvoQ=";
      }

      # nix
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.2.1";
        sha256 = "sha256-yC4ybThMFA2ncGhp8BYD7IrwYiDU3226hewsRvJYKy4=";
      }
      {
        name = "nix-env-selector";
        publisher = "arrterian";
        version = "1.0.9";
        sha256 = "sha256-TkxqWZ8X+PAonzeXQ+sI9WI+XlqUHll7YyM7N9uErk0=";
      }
    ];
  };

  xdg.configFile."VSCodium/User/settings.json".source = impurity.link ../vscodium/settings.json;
  xdg.configFile."VSCodium/User/keybindings.json".source = impurity.link ../vscodium/keybindings.json;
}
