(require 'package)
 (add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(setq package-enable-at-startup nil) (package-initialize)

;; Does not work?
;;   (package-install 'magit)
;; This does:
;;   M-x package-install RET magit RET
;; If things are foobar, try M-x package-refresh-contents
(setq magit-last-seen-setup-instructions "1.4.0")

;; Color Theme
(load-theme 'zenburn t)

;; Hightlight active window (panel) better.
;; M-x package-install smart-line-mode
;; (sml/setup)  TODO(wdm) Why doesn't this work on startup?


;; Minimal UI
(defalias 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)

(transient-mark-mode t)  ;; Show the current region.
(line-number-mode 1)     ;; Show row number.
(column-number-mode 1)   ;; Show column number.

;; TODO(wdm) Fix this.
;; (add-to-list 'load-path "~/.emacs.d")

;; Backups in /tmp
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Save history.
(savehist-mode 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))


;; Highlight words.
(defun font-lock-comment-annotations ()
  (font-lock-add-keywords
   nil '(
	 ("\\<\\(TODO\\|Note\\)" 1 font-lock-warning-face t)
	 ("\\<\\(HACK\\)" 1 '(:foreground "red") t)
	 )
   ))
(add-hook 'prog-mode-hook 'font-lock-comment-annotations)


;; Hightlight matching () []
(show-paren-mode)

;; Clang-format
;; sudo apt-get install clang-format-3.6
;; cd /usr/bin; sudo ln -s clang-format-3.6 clang-format
;; M-x package-install clang-format

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

;; (global-set-key "\C-w" 'backward-kill-word) TODO: C-backspace?
;; TODO(wdm) Add kill-region
(global-set-key (kbd "C-z") 'undo)
(global-unset-key (kbd "C-t"))  ;; Disable transpose.
(global-unset-key (kbd "C-x C-c"))  ;; Default exit is too easy to press.
(global-set-key (kbd "C-x C-c C-v") 'save-buffers-kill-emacs)
(global-set-key (kbd "C-x c") 'compile)
(global-set-key (kbd "C-c C-k") 'kill-compilation)
(global-set-key (kbd "C-x t") 'visit-ansi-term)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-x f") 'clang-format-buffer)
;; (global-set-key (kbd "C-x f") 'flyspell-mode)

;; Default keys to remember:
;;
;; M-$ - 'ispell-word
;; C-c left/right = navigate HTML tags.
;; M-w - 'kill-ring-save = Copy!

;; Auto-complete
(require 'ido)
(ido-mode t)

;; HTML

;; Download latest var.jar from http://validator.github.io/validator/
;; Unfortunately the gnu output isn't fully compile buffer comptabile, It outputs local
;; URLs like "file:/foo/bar.html" rather than filenames. This breaks error navigation.
(defun html5-validate()
  (interactive)
  (save-buffer)
  (compile (concat "java -jar ~/bin/vnu.jar " (shell-quote-argument (buffer-file-name)))))

(add-hook 'html-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c v") 'html5-validate)))

;; JavaScript

(setq js-indent-level 2)  ;; Google style.

;; (add-to-list 'load-path "~/.emacs.d/jshint-mode")
;; (require 'flymake-jshint)
;; (add-hook 'javascript-mode-hook
;;     (lambda () (flymake-mode t)))

;; Remote editing
(setq tramp-default-method "ssh")
(require 'tramp)

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


;; BUGS

;; emacsclient has 2s delay. See http://debbugs.gnu.org/cgi/bugreport.cgi?bug=17607.

(put 'upcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compilation-scroll-output t)
 '(custom-safe-themes
   (quote
    ("ff9e6deb9cfc908381c1267f407b8830bcad6028231a5f736246b9fc65e92b44" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
