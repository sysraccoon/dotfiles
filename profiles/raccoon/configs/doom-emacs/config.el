;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "sys.raccoon"
      user-mail-address "sys.raccoon@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "Hack" :size 14 :slant 'normal :weight 'normal))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/store/notes")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(defun parse-url (url)
  "convert a git remote location as a HTTP URL"
  (if (string-match "^http" url)
      url
    (replace-regexp-in-string "\\(.*\\)@\\(.*\\):\\(.*\\)\\(\\.git?\\)"
                              "https://\\2/\\3"
                              url)))
(defun magit-open-repo ()
  "open remote repo URL"
  (interactive)
  (let ((url (magit-get "remote" "origin" "url")))
    (progn
      (browse-url (parse-url url))
      (message "opening repo %s" url))))

(map! :after magit :map magit-mode-map
      "M-o" #'magit-open-repo)

(defun vterm-send-double-esc ()
  "Send double esc to vterm"
  (interactive)
  (progn
    (vterm-send-escape)
    (vterm-send-escape)))

(map! :after vterm :map vterm-mode-map
      ;; "M-ESC M-ESC" #'vterm-send-double-esc
      "M-c" (lambda () (interactive) (vterm-send "C-c")))

(use-package! org-appear
        :after org
        :hook (org-mode . org-appear-mode)
        :config
        (progn
          (setq org-appear-autoemphasis t)
          (setq org-appear-autolinks t)))

(use-package! org-fragtog
  :after org
  :hook (org-mode . org-fragtog-mode))

(after! org
  (progn
    (setq org-link-descriptive t)
    (setq org-hide-emphasis-markers t)

    ;; (make-directory "~/store/notes" :parents)
    ;; (setq org-roam-directory (file-truename "~/store/notes"))
    ;; (org-roam-db-autosync-mode)
    ))

(use-package! org-roam
  :after org
  :custom
  (org-roam-directory (file-truename "~/store/notes"))
  :config
  (org-roam-db-autosync-mode))

(map! "S-C-c" #'clipboard-kill-ring-save)
(map! "S-C-v" #'clipboard-yank)

(setq avy-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n ?s))

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))
