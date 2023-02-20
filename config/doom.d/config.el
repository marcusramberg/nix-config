;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Marcus Ramberg"
      user-mail-address "marcus.ramberg@gmail.com")

;; Look and feel
(setq doom-font "JetbrainsMono Nerd Font Mono-13"
      ; doom-variable-pitch-font (font-spec :family "futura" :size 13)
      doom-theme 'doom-nord ;; Current favorite
      display-line-numbers-type nil) ;; not worth the perf

;; Additional key mappings
(setq doom-localleader-key "\\")
(setq doom-localleader-alt-key "M-\\")
;; bindings
(map!
 (:leader
  (:prefix "f"
   :desc "Toggle Treemacs" "t" #'treemacs)
  (:prefix "o"
   :desc "Open kill ring" "k" #'+default/yank-pop)
  (:prefix "c"
   :desc "Accept Suggestion" "A" #'lsp-ui-sideline-apply-code-actions)
 ))

;; Various editor tweaks
;; Limit the length of visual mode.
  (add-hook 'visual-line-mode-hook #'visual-fill-column-mode)
  (setq visual-fill-column-width 100)
;; Enable auto save
(auto-save-visited-mode +1)

(setq projectile-project-search-path '("~/Source" "~/Source/reMarkable"))

;; be more evil
(after! evil
  (require 'evil-textobj-anyblock)
  (evil-define-text-object my-evil-textobj-anyblock-inner-quote
    (count &optional beg end type)
    "Select the closest outer quote."
    (let ((evil-textobj-anyblock-blocks
           '(("'" . "'")
             ("\"" . "\"")
             ("`" . "`")
             ("“" . "”"))))
      (evil-textobj-anyblock--make-textobj beg end type count nil)))

  (evil-define-text-object my-evil-textobj-anyblock-a-quote
    (count &optional beg end type)
    "Select the closest outer quote."
    (let ((evil-textobj-anyblock-blocks
           '(("'" . "'")
             ("\"" . "\"")
             ("`" . "`")
             ("“" . "”"))))
      (evil-textobj-anyblock--make-textobj beg end type count t)))
;; Allow multiple paste
  (defun evil-paste-after-from-0 ()
    (interactive)
    (let ((evil-this-register ?0))
      (call-interactively 'evil-paste-after)))
  (define-key evil-visual-state-map "p" 'evil-paste-after-from-0)

  (define-key evil-inner-text-objects-map "q" 'my-evil-textobj-anyblock-inner-quote)
  (define-key evil-outer-text-objects-map "q" 'my-evil-textobj-anyblock-a-quote)
  ;; Include _ in words.
  (add-hook 'prog-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  ;; Make splits behave more as expected
  (setq evil-split-window-below t
        evil-vsplit-window-right t)
  ;; Navigate our soft split lines.
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
)

;; Org config
(setq org-directory "~/org/")
(setq deft-directory org-directory)
(setq-hook! org-mode
  calendar-week-start-day 1
  org-agenda-block-separator (string-to-char "")
  org-agenda-breadcrumbs-separator " ❱ "
  org-agenda-compact-blocks t
  org-agenda-files (list "~/org/inbox.org"
                         "~/org/work.org"
                         "~/org/projects.org"
                         "~/org/chores.org"
                         "~/org/notes.org"
                         "~/org/home.org")
  org-clock-into-drawer t
  org-clock-persist t
  org-columns-default-format "%60ITEM(Task) %20TODO %10Effort(Effort){:} %10CLOCKSUM"
  org-confirm-babel-evaluate nil
  org-duration-format '((special . h:mm))
  org-ellipsis "…"
  org-fontify-done-headline t
  org-fontify-quote-and-verse-blocks t
  org-fontify-whole-heading-line t
  org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                ("STYLE_ALL" . "habit")))
  org-hide-emphasis-markers t
  org-icalendar-timezone "Europe/Oslo"
  org-image-actual-width '(700)
  org-log-done t
  org-log-into-drawer t
  org-modules (quote (org-protocol))
  org-refile-targets '((org-agenda-files :maxlevel . 2))
  org-time-clocksum-format (quote (:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))
  org-todo-keywords '((sequence "TODO(t!)" "WAITING(w!)" "INPROGRESS(p!)"  "|" "DONE(d!) OBSOLETE(o!)") (sequence "IDEA(i!)" "MAYBE(y!)" "STAGED(s!)" "WORKING(k!)" "|" "USED(u!/@)"))
  )

;; Capture
(after! org
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/org/inbox.org" "Tasks") "* TODO %?\n %i\n %a")
          ("j" "Journal" entry (file+olp+datetree "~/org/journal.org") "* %?\nEntered on %U\n %i\n %a")
          ("p" "Protocol" entry (file+headline "~/org/inbox.org" "Bookmarks")
           "* %? [[%:link][%:description]]\n#+begin_quote\n%i\n:+end_quote\nCaptured On: %U"
           :empty-lines 1)
          ("L" "Protocol Link" entry (file+headline "~/org/inbox.org" "Bookmarks")
           "* %? [[%:link][%:description]]\nCaptured On: %U"
           :empty-lines 1)
          ("K" "Cliplink capture task" entry (file "")
           "* TODO %(org-cliplink-capture) \n  SCHEDULED: %t\n" :empty-lines 1)
          ("c" "Cookbook" entry (file+headline "~/org/cooking.org" "Inbox")
           "%(org-chef-get-recipe-from-url)"
           :empty-lines 1)
          ("M" "Manual Cookbook" entry (file+headline "~/org/cooking.org" "Inbox")
           "* %^{Recipe title: }\n  :PROPERTIES:\n  :source-url:\n  :servings:\n  :prep-time:\n  :cook-time:\n  :ready-in:\n  :END:\n** Ingredients\n   %?\n** Directions\n\n")
          ))

  ;; Icons
  (customize-set-value
    'org-agenda-category-icon-alist
    `(
      ("work" ,(list (all-the-icons-material "work" :height 1.2)) nil nil :ascent center)
      ("chore" ,(list (all-the-icons-material "repeat" :height 1.2)) nil nil :ascent center)
      ("events" ,(list (all-the-icons-faicon "calendar" :height 1.2)) nil nil :ascent center)
      ("inbox" ,(list (all-the-icons-material "check_box" :height 1.2)) nil nil :ascent center)
      ("blog" ,(list (all-the-icons-material "rss_feed" :height 1.2)) nil nil :ascent center)
      ("home" ,(list (all-the-icons-material "home" :height 1.2)) nil nil :ascent center)
      ("cooking" ,(list (all-the-icons-material "kitchen" :height 1.2)) nil nil :ascent center)
     ))
  (setq org-agenda-format-date 'my-org-agenda-format-date-aligned)
  (defun my-org-agenda-format-date-aligned (date)
  "Format a DATE string for display in the daily/weekly agenda, or timeline.
This function makes sure that dates are aligned for easy reading."
  (require 'cal-iso)
  (let* ((dayname (calendar-day-name date 1 nil))
         (day (cadr date))
         (day-of-week (calendar-day-of-week date))
         (month (car date))
         (monthname (calendar-month-name month 1))
         (year (nth 2 date))
         (iso-week (org-days-to-iso-week
                    (calendar-absolute-from-gregorian date)))
         (weekyear (cond ((and (= month 1) (>= iso-week 52))
                          (1- year))
                         ((and (= month 12) (<= iso-week 1))
                          (1+ year))
                         (t year)))
         (weekstring (if (= day-of-week 1)
                         (format " W%02d" iso-week)
                       "")))
         (format "%-2s. %2d %s"
            dayname day monthname)))

(setq org-agenda-custom-commands
      '(("o" "My Agenda"
         ((todo "INPROGRESS" (
                      (org-agenda-overriding-header "\n⚡ in progress:\n⎺⎺⎺⎺⎺⎺⎺⎺⎺")
                      (org-agenda-remove-tags t)
                      (org-agenda-prefix-format " %-2i %-15b")
                      (org-agenda-todo-keyword-format "")
                       ))
          (agenda "" (
                      (org-agenda-start-day "+0d")
                      (org-agenda-span 5)
                      (org-agenda-overriding-header "⚡ Schedule:\n⎺⎺⎺⎺⎺⎺⎺⎺⎺")
                      (org-agenda-repeating-timestamp-show-all nil)
                      (org-agenda-remove-tags t)
                      (org-agenda-prefix-format   "  %-3i  %-15b %t%s")
                      (org-agenda-todo-keyword-format " ☐ ")
                      (org-agenda-current-time-string "⮜┈┈┈┈┈┈┈ now")
                      (org-agenda-scheduled-leaders '("" ""))
                      (org-agenda-time-grid (quote ((daily today remove-match)
                                                    (0900 1200 1500 1800 2100)
                                                    "      " "┈┈┈┈┈┈┈┈┈┈┈┈┈")))
                       ))
          ))))

  (add-hook 'org-agenda-finalize-hook #'set-window-clean)
  (defun set-window-clean ()
    (interactive)
    (setq mode-line-format nil)
    (set-frame-parameter nil 'font "JetbrainsMono Nerd Font-16")
    (set-window-margins (frame-selected-window) 4))


  ;; Jira
  (make-directory "~/.org-jira" 'ignore-if-exists)
  (setq jiralib-url "https://getremarkable.atlassian.net")
  (setq jiralib-update-issue-fields-exclude-list '(priority reporter))
  (setq org-jira-keywords-to-jira-status-alist
        '(("In Progress" . "INPROGRESS")
          ("To Do" . "TODO")
          ("Code Review" . "PR")))

)



;; Configure jsonnet to use grafonnet
(setq jsonnet-enable-debug-print t)
(setq jsonnet-library-search-directories "grafonnet-lib")


;; Blogging config
(setq HUGO_BASE_DIR "~/Source/blog")

(after! org
  (defun org-hugo-new-subtree-post-capture-template ()
    "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title))
           (slug (concat (format-time-string "%Y-%m-%d") "-" fname)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " slug)
                   ":END:"
                   "%?\n")          ;Place the cursor here finally
                 "\n")))

  (add-to-list 'org-capture-templates
               '("h"                ;`org-capture' binding + h
                 "Hugo post"
                 entry
                 (file+olp "blog.org" "Posts")
                 (function org-hugo-new-subtree-post-capture-template)))

  (defun org-hugo-new-subtree-link-capture-template ()
    "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (link (read-from-minibuffer "Post Link: ")) ;Prompt to enter the post link
           (fname (org-hugo-slug title))
           (slug (concat (format-time-string "%Y-%m-%d") "-" fname)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO "  title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " slug)
                   ,(concat ":EXPORT_HUGO_CUSTOM_FRONT_MATTER: :externalUrl " link)
                   ":END:"
                   "%?\n")          ;Place the cursor here finally
                 "\n")))

  (add-to-list 'org-capture-templates
               '("H"                ;`org-capture' binding + H
                 "Hugo link"
                 entry
                 (file+olp "blog.org" "Links")
                 (function org-hugo-new-subtree-link-capture-template))))


;; Mac specfic config
(setq mac-option-key-is-meta t)
(setq mac-right-option-modifier nil)

;; LSP
(after! lsp
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("/Users/marcus/Downloads/terraform-ls" "serve"))
                    :major-modes '(terraform-mode)
                    :server-id 'terraform-ls))
  (make-lsp-client :new-connection (lsp-stdio-connection '("perl" "-M Perl::LanguageServer"))
                    :major-modes '(cperl-mode)
                    :server-id 'perl-ls)
  (add-hook 'terraform-mode-hook #'lsp))



(setq jenkins-api-token "invalid"
      jenkins-url "https://jenkins.tech.dnb.no/jenkinsssl/"
      jenkins-username "marcus.ramberg"
      jenkins-viewname "Favorites") ;; if you're not using views skip this line
;;
;; Perl
(defalias 'perl-mode 'cperl-mode)
(setq flycheck-perlcritic-theme "freenode"
      cperl-electric-keywords t)

(defun zakame/reply-sentinel (process event)
  (if (memq (process-status process) '(signal exit))
      (let ((buffer (process-buffer process)))
        (kill-buffer buffer))))
(defadvice run-reply (around reply-set-process-sentinel activate)
  ad-do-it
  (set-process-sentinel (get-process "reply") 'zakame/reply-sentinel))
(ad-activate 'run-reply)
; (defun reply-other-window ()
;   "Run `reply' on other window."
;   (interactive)
;   (switch-to-buffer-other-window (get-buffer-create "*reply*"))
;   (run-reply "reply"))
(after! helm-perldoc
  (helm-perldoc:setup))

  ; (map! (:localleader  ; Use local leader
  ;        (:map (cperl-mode-map)
  ;         (:prefix ("r" . "repl")
          ; "r" #'run-reply ; Add which-key description
          ; "o" #'reply-other-window)
; "s" #'reply-send-region
          ; (:prefix ("t" . "tidy")
          ; "r" #'perltidy-region
          ; "b" #'perltidy-buffer
          ; "s" #'perltidy-subroutine
          ; "t" #'perltidy-dwim-safe)
        ;   "p" #'helm-perldoc
        ; )))

(after! company-ctags
  (add-to-list 'company-backends 'company-ctags)
  (add-hook 'cperl-mode-hook 'company-mode))

;;mu4e
(set-email-account! "marcus.ramberg"
  '((mu4e-sent-folder       . "/means.no/Sent Mail")
    (mu4e-drafts-folder     . "/means.no/Drafts")
    (mu4e-trash-folder      . "/means.no/Trash")
    (mu4e-refile-folder     . "/means.no/All Mail")
    (smtpmail-smtp-user     . "marcus@means.no")
    (user-mail-address      . "marcus@means.no")    ;; only needed for mu < 1.4
    (mu4e-compose-signature . "---\nMarcus Ramberg"))
  t)


;; Slack config
; (after! slack
;   (setq slack-buffer-emojify t) ;; if you want to enable emoji, default nil
;   (setq slack-prefer-current-team t)
;   (slack-register-team
;         :name "dnb-it"
;         :token "censored" ;;(auth-source-pick-first-password
;             ;;    :name "dnb-it.slack.com"
;             ;;    :user "marcus.ramberg@dnb.no")
;         :subscribed-channels '(the-hideout inf-cshasl-private inf-eventhub-private))
;   (evil-define-key 'normal slack-info-mode-map
;     ",u" 'slack-room-update-messages)
;   (evil-define-key 'normal slack-mode-map
;     ",c" 'slack-buffer-kill
;     ",ra" 'slack-message-add-reaction
;     ",rr" 'slack-message-remove-reaction
;     ",rs" 'slack-message-show-reaction-users
;     ",pl" 'slack-room-pins-list
;     ",pa" 'slack-message-pins-add
;     ",pr" 'slack-message-pins-remove
;     ",mm" 'slack-message-write-another-buffer
;     ",me" 'slack-message-edit
;     ",md" 'slack-message-delete
;     ",u" 'slack-room-update-messages
;     ",2" 'slack-message-embed-mention
;     ",3" 'slack-message-embed-channel
;     "\C-n" 'slack-buffer-goto-next-message
;     "\C-p" 'slack-buffer-goto-prev-message)
;    (evil-define-key 'normal slack-edit-message-mode-map
;     ",k" 'slack-message-cancel-edit
;     ",s" 'slack-message-send-from-buffer
;     ",2" 'slack-message-embed-mention
;     ",3" 'slack-message-embed-channel))

;; Autoload jq.
(add-to-list 'auto-mode-alist '("\\.jq$" . jq-mode))

;; Autosave before magit
(after! magit (setq magit-save-repository-buffers 'dontask))


(add-hook! 'emacs-startup-hook
  (menu-bar-mode -1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(org-plus-contrib lsp-origami cheat-sh jenkins-watch elscreen jenkins)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(setq dash-docs-docsets '("NodeJS" "Javascript" "HTML"))


;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (("C-TAB" . 'copilot-accept-completion-by-word)
         ("C-<tab>" . 'copilot-accept-completion-by-word)
         :map copilot-completion-map
         ("<tab>" . 'copilot-accept-completion)
         ("TAB" . 'copilot-accept-completion)))
