;;; .emacs --- Will's .emacs file.
;;; Commentary:
;; TODO(wdm) Review https://github.com/manugoyal/.emacs.d

;;; Code:

(require 'package)
(setq package-enable-at-startup nil)  ;; But don't load all the packages.
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; Bootstrap 'use-package' https://github.com/jwiegley/use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;; TODO(wdm) Clean up use of :defer t - implied if :bind or :map used.
;; TODO(wdm) Clean up :ensure t - (setq use-package-always-ensure t)

;;;;;;;;;;;;;;
;; Packages ;;
;;;;;;;;;;;;;;

;; For defining keyboard bindings
(use-package bind-key
  :ensure t)

(use-package exec-path-from-shell
  :disabled ;; HACK
  :if (memq window-system '(mac ns))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; sudo yarn global add eslint babel-eslint eslint-plugin-react

;; In-place error highlighting.
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode)
  ;; disable jshint since we prefer eslint checking.
  ;; What is TODO(wdm) jsonlist ??
  (setq-default flycheck-disabled-checkers '(javascript-jshint))
  ;; use eslint with web-mode for jsx files
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  ;; customize flycheck temp file prefix
  (setq flycheck-temp-prefix ".flycheck"))

;; Shell lint
;; apt-get install shellcheck
(use-package flymake-shellcheck
  :ensure t
  :commands flymake-shellcheck-load
  :init
  (add-hook 'sh-mode-hook 'flymake-shellcheck-load))

;; For React JSX is .js files.
(use-package rjsx-mode
  :ensure t
  :defer t
  :mode ("\\.js" "\\.jsx")
  :config
  (define-key rjsx-mode-map "<" nil))


;; Manual magit install
;; (add-to-list 'load-path "~/.emacs.d/site-lisp/magit/lisp")
;; (require 'magit)
;; (bind-key "C-x g" 'magit-status)

;; Amazing git diff!
;; Show output from commit hook.
 (use-package magit
   :ensure t
   :defer t
   :bind ("C-x g" . magit-status)
)
;; Exclude Expo crap by default.
(setq-default vc-git-grep-template "git --no-pager grep -n <C> -e <R> -- <F> ':(exclude)**android/**' ':(exclude)**ios/**' ':(exclude)*.lock'")

;; Dark color theme.
(use-package hc-zenburn-theme
  :ensure t
  :config (load-theme 'hc-zenburn t))

;; go-fmt for other languages.
;; clang-format -style=Chromium -dump-config > ~/.clang-format
(use-package clang-format
  :ensure t
  :defer t
  :config (setq clang-format-style "Chromium"))

;; Emacs remote shell editing.
;; See .bash_profile for PROMPT_COMMAND requirements.
(use-package tramp
   :ensure t
   :defer t
   :config
   ;; http://emacs.stackexchange.com/questions/18438
   ;; Emacs suspend at startup ssh connection issue
   ;; (setq tramp-ssh-controlmaster-options
   ;;      "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=no"
   ;;      )
   ;; (setq tramp-default-method "ssh"))
   ;; (setq tramp-verbose 6) ;; Debugging.
   ;; (add-to-list 'tramp-remote-path "/mnt/usb/usr/bin")
   ;; (add-to-list 'tramp-remote-path "/mnt/usb/bin")
)

;; Auto-complete
;; https://writequit.org/denver-emacs/presentations/2017-04-11-ivy.html
(use-package ivy
  :demand
  :ensure t
  :config
  (setq ivy-use-virtual-buffers t
        ivy-mode 1
        ivy-count-format "%d/%d "))
(use-package counsel
  :ensure t)
(use-package counsel-projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

;; (use-package ido
;;   :ensure t
;;   :config
;;   (ido-mode 1)
;;   (setq ido-max-work-file-list 100  ;; Remember lots of visited files.
;;         confirm-nonexistent-file-or-buffer nil) ;; Don't prompt again.
;;   (ido-everywhere 1))

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
  :bind ("C-t" . whitespace-mode) ;; Toggle showing whitespace
  :init (add-hook 'prog-mode-hook (lambda ()
                              (when (eq major-mode 'js2-mode)
                                (setq whitespace-line-column 120))
                              (whitespace-mode)
                              ))
  ;; TODO(wdm) Cleaner fix to whitespace UI problems.
  :config
  (set-face-attribute 'whitespace-space nil :background "gray21")
  ;; JS with JSX is really verbose. Allow wider lines.
  )


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

;; Yocto Bitbake
(use-package bitbake
  :ensure t
  :defer t
  :mode (("\\.bb" . bitbake-mode)
         ("\\.inc" . bitbake-mode)
         ("\\.bbappend" . bitbake-mode)))

;; CMake
(use-package cmake-mode
  :ensure t
  :defer t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))


(defun insert-header-guard ()
  "Insert header guard in C/C++ header file.
Recognized extensions: .h, .hh or .hxx"
  (interactive)
  (if (string-match "\\.h\\(h\\|xx\\)?\\'" (file-name-nondirectory buffer-file-name))
      (let ((header-guard
             (concat
              (upcase (replace-regexp-in-string "[-.]" "_" (file-name-nondirectory buffer-file-name)))
              "_")))
        (save-excursion
          (goto-char (point-min))
          (insert "#ifndef " header-guard "\n")
          (insert "#define " header-guard "\n\n")
          (goto-char (point-max))
          (insert "\n#endif /* !" header-guard " */\n")))
    (message "Invalid C/C++ header file.")))

;; Lua

(defun luafmt ()
  "Run luafmt current file and revert the buffer."
  (interactive)
  (shell-command
   (format "luafmt %s"
       (shell-quote-argument (buffer-file-name))))
  (revert-buffer t t t))

;; sudo luarocks install luacheck # For flycheck.
(use-package lua-mode
  :ensure t
  :defer t
  :bind ("C-x f" . luafmt)
  :mode "\\.lua")


;; HTML/XML/JavaScript
(use-package js2-mode
  :ensure t
  :mode ("\\.js" "\\.mjs")
  :config
  ;; Use flycheck and eslint for warnings.
  (setq js2-mode-show-parse-errors nil)
  (setq js2-mode-show-strict-warnings nil)
)

;; gofmt for JavaScript
;; https://github.com/jscheid/prettier.el - Unofficial but more active than prettier-js
(use-package prettier
  :ensure t
  :defer t
;;  :bind (:map js-mode-map ("C-x f" . prettier-prettify)) ;; Override clang-format
  :init (global-prettier-mode)
)

(use-package tide
  :ensure t
  :mode ("\\.ts\\'" . typescript-mode))

;; Download latest var.jar from http://validator.github.io/validator/
;; Unfortunately the gnu output isn't fully compile buffer comptabile, It
;; outputs local URLs like "file:/foo/bar.html" rather than filenames. This
;; breaks error navigation.
(defun html5-validate()
  "Validate current file as valid HTML5."
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

(use-package go-mode
  :ensure t
  :mode "\\.go\\'"
  :init
  (add-hook 'before-save-hook 'gofmt-before-save t)
)

(use-package json-mode
  :ensure t
)

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
         ("\\<\\(HACK\\|FIXME\\)" 1 '(:foreground "red") t)
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
  "Switch to *ansi-term* buffer, creating it if necessary."
  (interactive)
  (if (get-buffer "*ansi-term*")
      (switch-to-buffer "*ansi-term*")
    (ansi-term "/bin/bash")))

(add-to-list 'auto-mode-alist '("\\.rc$" . sh-mode))
;;;;;;;;;;
;; Keys ;;
;;;;;;;;;;

;; TODO(wdm) Use bind.

;; (global-set-key "\C-w" 'backward-kill-word) TODO: C-backspace?
;; TODO(wdm) Add kill-region
(global-set-key (kbd "C-z") 'undo)
(global-unset-key (kbd "C-x C-c"))  ;; Default exit is too easy to press.
(global-set-key (kbd "C-x C-c C-v") 'save-buffers-kill-emacs)
(global-set-key (kbd "C-x c") 'compile)
(global-set-key (kbd "C-c C-k") 'kill-compilation)
(global-set-key (kbd "C-x t") 'visit-ansi-term)
(global-set-key (kbd "C-x y") (lambda () (interactive) (ansi-term "/bin/bash")))


(global-set-key (kbd "C-c l") 'toggle-truncate-lines)
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
