;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Marcus Ramberg"
      user-mail-address "marcus@means.no")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 12 :weight 'semi-light)
     doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font Propo" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tokyo-night)
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
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

;;
;;; Ported from ~/.config/nvim

;; Transparent frame (neovide_opacity = 0.9)
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; Projects: autodiscover under ~/Source and ~/Source/reMarkable (SPC p p)
(setq projectile-project-search-path '("~/Source" "~/Source/reMarkable")
      projectile-auto-discover t)

;; Keymaps: C-p = find file in project, U = redo, jj = escape
(map! :nvi "C-p" #'projectile-find-file
      :n "U" #'evil-redo)
(setq evil-escape-key-sequence "jj")

;; Autosave after a delay (auto-save.nvim)
(setq auto-save-visited-interval 1)
(auto-save-visited-mode 1)

;; Soft wrap in prose/commits (spell is already on via :checkers spell)
(add-hook! '(markdown-mode-hook git-commit-mode-hook) #'visual-line-mode)

;; gx opens in firefox, new tab
(setq browse-url-browser-function #'browse-url-firefox
      browse-url-firefox-new-window-is-tab t)

;; Org: default capture target like org_default_notes_file
(setq +org-capture-notes-file "refile.org")

;; LSP server settings (gopls / yamlls / nil)
(setq-default eglot-workspace-configuration
              '(:gopls (:gofumpt t :staticcheck t :usePlaceholders t :completeUnimported t
                        :analyses (:nilness t :unusedparams t :unusedwrite t :useany t)
                        :hints (:assignVariableTypes t :compositeLiteralFields t
                                :compositeLiteralTypes t :constantValues t
                                :functionTypeParameters t :parameterNames t
                                :rangeVariableTypes t))
                :yaml (:keyOrdering :json-false)
                :nil (:nix (:flake (:autoArchive t)))))

;; Copilot (run M-x copilot-install-server, then M-x copilot-login once)
(use-package! copilot
  :defer t
  :init
  (add-hook! '(prog-mode-hook text-mode-hook conf-mode-hook)
    (defun +copilot-maybe-enable-h ()
      ;; copilot-mode errors (and breaks startup) if the server isn't installed
      (when (and (require 'copilot nil t) (ignore-errors (copilot-server-executable)))
        (copilot-mode 1))))
  :config
  (map! :map copilot-completion-map
        "<tab>" #'copilot-accept-completion
        "TAB"   #'copilot-accept-completion))

;; Devdocs (devdocs.nvim)
(map! :leader :prefix "h"
      :desc "Devdocs lookup"  "o" #'devdocs-lookup
      :desc "Devdocs install" "O" #'devdocs-install)

;; el-rio terminal; first run builds the native module with cargo
(defun +rio/popup ()
  "Open a rio terminal in a bottom popup window."
  (interactive)
  ;; rio uses `switch-to-buffer'; this makes it go through the popup rule below
  (let ((switch-to-buffer-obey-display-actions t)) (rio)))
(use-package! rio
  :commands rio
  :init
  (map! :leader
        :desc "Rio terminal popup" "o t" #'+rio/popup
        :desc "Rio terminal here"  "o T" #'rio)
  (set-popup-rule! "^\\*rio" :size 0.3 :vslot -4 :select t :quit nil :ttl 0)
  :config (set-evil-initial-state! 'rio-mode 'emacs))
