(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

;; Does not work?
;;   (package-install 'magit)
;; This dones:
;;   M-x package-install RET magit RET

;; Color Theme
(load-theme 'zenburn t)

;; Minimal UI
(defalias 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(menu-bar-mode -1)

(transient-mark-mode t)  ;; Show the current region.
(line-number-mode 1)     ;; Show row number.
(column-number-mode 1)   ;; Show column number.

(add-to-list 'load-path "~/.emacs.d")

;; C
(require 'clang-format)

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
(global-unset-key (kbd "C-x C-c"))
(global-set-key (kbd "C-x C-c C-v") 'save-buffers-kill-terminal)
(global-set-key (kbd "C-x c") 'compile)
(global-set-key (kbd "C-x t") 'visit-ansi-term)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "M-g") 'goto-line)

;; Auto-complete
(require 'ido)
(ido-mode t)


;; BUGS

;; emacsclient has 2s delay. See http://debbugs.gnu.org/cgi/bugreport.cgi?bug=17607.

