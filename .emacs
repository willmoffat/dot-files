;;; .emacs --- Will's .emacs file.
;;; Commentary:
;; TODO(wdm) Review https://github.com/manugoyal/.emacs.d

;;; Code:

(require 'package)
(setq package-enable-at-startup nil)  ;; But don't load all the packages.
(add-to-list 'package-archives
             '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Bootstrap 'use-package' https://github.com/jwiegley/use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;;;;;;;;;;;;;;
;; Packages ;;
;;;;;;;;;;;;;;

;; For defining keyboard bindings
(use-package bind-key
  :ensure t)

;; In-place error highlighting.
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Amazing git diff!
;; Show output from commit hook.
(use-package magit
  :ensure t
  :defer t
  :bind ("C-x g" . magit-status)
  :init (setq magit-last-seen-setup-instructions "1.4.0")
  :config
  (add-hook 'git-commit-mode-hook
            (lambda () (save-selected-window (magit-process)))))

;; Dark color theme.
(use-package zenburn-theme
  :ensure t
  :config (load-theme 'zenburn t))

;; go-fmt for other languages.
;; sudo apt-get install clang-format-3.6
;; cd /usr/bin; sudo ln -s clang-format-3.6 clang-format
(use-package clang-format
  :ensure t
  :defer t
  :config (setq clang-format-style "Chromium"))

;; Remote editing
;;  - Add this to .bash_profile on remote machines
;; function set-eterm-dir {
;;   echo -e "\033AnSiTu" "$LOGNAME"
;;   echo -e "\033AnSiTc" "$(pwd)"
;;   echo -e "\033AnSiTh" "SSH_PROFILE_NAME_OR_HOSTNAME"
;;   history -a # Write history to disk.
;; }
;; # Track directory, username, and cwd for remote logons.
;; if [ "$TERM" = "eterm-color" ]; then
;;   PROMPT_COMMAND=set-eterm-dir
;; fi
(use-package tramp
  :ensure t
  :defer t
  :config
  ;; (setq tramp-verbose 6) ;; Debugging for Muusedong.
  ;; (add-to-list 'tramp-remote-path "/mnt/usb/usr/bin")
  ;; (add-to-list 'tramp-remote-path "/mnt/usb/bin")
  (setq tramp-default-method "ssh"))

;; Auto-complete
(use-package ido
  :ensure t
  :config
  (ido-mode 1)
  (ido-everywhere 1))

;; camelCase Navigation
;; We want to navigate camelCase words as separate words.
(use-package subword
  :diminish subword-mode
  :init
  (global-subword-mode))

;; Ediff - don't popup a navigation frame.
 (use-package ediff
   :config
   (setq diff-switches               "-u"
         ediff-custom-diff-options   "-U3"
         ediff-split-window-function 'split-window-horizontally
         ediff-window-setup-function 'ediff-setup-windows-plain)
   (add-hook 'ediff-startup-hook 'ediff-toggle-wide-display)
   (add-hook 'ediff-cleanup-hook 'ediff-toggle-wide-display)
   (add-hook 'ediff-suspend-hook 'ediff-toggle-wide-display))

;; Spell Checking
;; Remember: M-$ - 'ispell-word
(use-package flyspell
  :ensure t
  :defer t
  :init
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  (add-hook 'text-mode-hook 'flyspell-mode))

;; Kill whitespace!
(use-package whitespace
  :ensure t
  :defer t
  :diminish whitespace-mode
  :init (add-hook 'prog-mode-hook 'whitespace-mode)
  ;; TODO(wdm) Cleaner fix to whitespace UI problems.
  :config (set-face-attribute 'whitespace-space nil :background "gray25"))


;; Trim extra white-space in lines edited.
(use-package ws-butler
  :ensure t
  :diminish ws-butler-mode
  :config
  (add-hook 'prog-mode-hook 'ws-butler-mode)
  (add-hook 'yaml-mode-hook 'ws-butler-mode))

;; Yaml
(use-package yaml-mode
  :ensure t
  :defer t
  :config
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
  (add-hook 'yaml-mode-hook
            '(lambda ()
               (define-key yaml-mode-map "\C-m" 'newline-and-indent))))
;; Markdown
(use-package markdown-mode
  :ensure t
  :defer t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

;; Lua
;; sudo luarocks install luacheck # For flycheck.
(use-package lua-mode
  :ensure t
  :defer t
  :mode "\\.lua")

;; HTML/XML/JavaScript
(use-package js2-mode
  :ensure t
  :mode ("\\.js" "\\.gs")
 ;; :config (setq js-indent-level 2)  ;; Google style.
  )

;; Download latest var.jar from http://validator.github.io/validator/
;; Unfortunately the gnu output isn't fully compile buffer comptabile, It
;; outputs local URLs like "file:/foo/bar.html" rather than filenames. This
;; breaks error navigation.
(defun html5-validate()
  (interactive)
  (save-buffer)
  (compile (concat "java -jar ~/bin/vnu.jar "
                   (shell-quote-argument (buffer-file-name)))))

(use-package web-mode
  :ensure t
  :mode "\\.html"
  :bind ("C-c v" . html5-validate)
  :config
  (add-hook 'web-mode-hook (lambda () (whitespace-mode -1)))
  ;; Highlight &amp;
  (set-face-attribute 'web-mode-html-entity-face nil :foreground "chocolate")
  (setq web-mode-enable-html-entities-fontification t)
  ;; Highlight <style> and <script> sections.
  (set-face-attribute 'web-mode-block-face nil :background "#555")
  (setq web-mode-enable-part-face t)
  ;; TODO(wdm) Figure out how to use my global lights.
  (set-face-attribute 'web-mode-comment-keyword-face nil :foreground "orange red")
  ;; Misc
  (setq web-mode-enable-current-element-highlight t))

;; Support Chrome extension Emacs Edit.
(use-package edit-server
  :if window-system  ;; Only run if in a GUI.
  :ensure t
  :defer t
  :init
  (add-hook 'after-init-hook 'server-start t)
  (add-hook 'after-init-hook 'edit-server-start t))

;; Support programs generating color output in compile buffer.
;; Based on http://stackoverflow.com/questions/3072648/
(use-package ansi-color
  :ensure t
  :init
  (defun my-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer))

;;;;;;;;;;;;;;;;;;;
;; General setup ;;
;;;;;;;;;;;;;;;;;;;

;; UTF-8 Encoding
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq current-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(setenv "LC_CTYPE" "UTF-8")

;; Minimal UI
(defalias 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Don't use tabs.
(setq-default indent-tabs-mode nil)

;; M-a - Move to sentence start.
;; M-e - Move to sentence end.
(setq sentence-end-double-space nil)

(transient-mark-mode t)  ;; Show the current region.
(line-number-mode 1)     ;; Show row number.
(column-number-mode 1)   ;; Show column number.

;; Backups in /tmp
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Save history.
(savehist-mode 1)
(defvar savehist-additional-variables
  '(kill-ring search-ring regexp-search-ring))


(defun font-lock-comment-annotations ()
  "Words to highlight."
  (font-lock-add-keywords
   nil '(
         ("\\<\\(TODO\\|Note\\)" 1 font-lock-warning-face t)
         ("\\<\\(HACK\\)" 1 '(:foreground "red") t)
         )
   ))
(add-hook 'prog-mode-hook 'font-lock-comment-annotations)


;; Hightlight matching () []
(show-paren-mode)

;; Lua
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

(defun visit-ansi-term()
  "Switch to *ansi-term* buffer, creating it if necessary"
  (interactive)
  (if (get-buffer "*ansi-term*")
      (switch-to-buffer "*ansi-term*")
    (ansi-term "/bin/bash")))

;;;;;;;;;;
;; Keys ;;
;;;;;;;;;;

;; TODO(wdm) Use bind.

;; (global-set-key "\C-w" 'backward-kill-word) TODO: C-backspace?
;; TODO(wdm) Add kill-region
(global-set-key (kbd "C-z") 'undo)
(global-unset-key (kbd "C-t"))  ;; Disable transpose.
(global-unset-key (kbd "C-x C-c"))  ;; Default exit is too easy to press.
(global-set-key (kbd "C-x C-c C-v") 'save-buffers-kill-emacs)
(global-set-key (kbd "C-x c") 'compile)
(global-set-key (kbd "C-c C-k") 'kill-compilation)
(global-set-key (kbd "C-x t") 'visit-ansi-term)

(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-x f") 'clang-format-buffer)

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-0") 'text-scale-set)

;; Default keys to remember:
;;
;; C-c left/right = navigate HTML tags.
;; M-w - 'kill-ring-save = Copy!

;; Android
;; (setq android-mode-sdk-dir "/opt/android") ;; TODO(wdm): Use $ANDROID_HOME
;; (require 'android-mode)
;; (require 'android)

;; BUGS

;; emacsclient has 2s delay.
;; See http://debbugs.gnu.org/cgi/bugreport.cgi?bug=17607.

;; Enabled commands.
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Compiling.
(setq compilation-scroll-output t)

(provide '.emacs)
;;; .emacs ends here
