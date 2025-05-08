;;; init.el --- Main Emacs Configuration -*- lexical-binding: t; -*-

;; ------------------------------
;; Startup & UI
;; ------------------------------

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(add-hook 'window-setup-hook 'toggle-frame-fullscreen)

(setq inhibit-startup-screen t
      make-backup-files nil
      auto-save-default nil
      create-lockfiles nil
      ring-bell-function 'ignore
      use-dialog-box nil
      visible-bell t
      warning-minimum-level :emergency
      mouse-wheel-text-scale-ignore t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(recentf-mode 1)
(add-hook 'emacs-lisp-mode-hook #'format-all-mode)

(load-theme 'modus-operandi t)
(set-frame-font "IBM Plex Mono 15" nil t)

(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

(global-set-key (kbd "C-c a") 'mark-whole-buffer)
(setq eldoc-echo-area-use-multiline-p nil)

;; ------------------------------
;; Package Management
;; ------------------------------

(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

(setq use-package-always-ensure t)

;; ------------------------------
;; Essential Packages
;; ------------------------------

(use-package which-key
  :config (which-key-mode))

(use-package vertico
  :init (vertico-mode)
  :config
  (setq vertico-count 20))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil))

(use-package marginalia
  :after vertico
  :init (marginalia-mode))

(use-package consult
  :bind (("C-s"     . consult-line)
         ("C-x b"   . consult-buffer)
         ("C-x C-r" . consult-recent-file)
         ("M-y"     . consult-yank-pop)
         ("C-c f"   . consult-ripgrep)
         ("C-c g"   . consult-git-grep)
         ("C-c k"   . consult-grep)
         ("C-c m"   . consult-imenu)
         ("C-c e"   . consult-eglot-symbols))
  :config
  (setq consult-narrow-key "<"
        consult-preview-key 'any
        completion-styles '(orderless)))

(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 1
        company-tooltip-align-annotations t))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; ------------------------------
;; Language Support
;; ------------------------------

(use-package eglot
  :ensure nil  ;; built-in in Emacs 29+
  :hook ((haskell-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (python-mode . eglot-ensure))
  :config
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'eglot-format-buffer -10 t)))
  (setq eglot-extend-to-xref t))

(use-package consult-eglot
  :after (consult eglot))

(use-package haskell-mode
  :hook ((haskell-mode . interactive-haskell-mode)
         (haskell-mode . eglot-ensure)))

(use-package rust-mode
  :mode "\\.rs\\'"
  :hook ((rust-mode . eglot-ensure)
         (rust-mode . (lambda ()
                        (setq indent-tabs-mode nil
                              rust-format-on-save t)))))

(add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-mode t)
;; ------------------------------
;; Formatting Utilities
;; ------------------------------

(use-package format-all
  :hook ((prog-mode . format-all-ensure-formatter))
  :config
  (add-hook 'prog-mode-hook 'format-all-mode))

;; (defun my/format-buffer ()
;;   "Try `eglot-format-buffer'. If it fails, use `format-all-buffer'."
;;   (interactive)
;;   (condition-case err
;;       (eglot-format-buffer)
;;     (error
;;      (message "eglot-format-buffer failed: %s; falling back to format-all-buffer" err)
;;      (format-all-buffer))))

;; (defun my/format-and-save-buffer ()
;;   "Format the current buffer and save it. Use eglot if available, otherwise format-all."
;;   (interactive)
;;   (my/format-buffer)
;;   (save-buffer))

;; (global-set-key (kbd "C-c C-f" ) #'my/format-buffer)
;; (global-set-key (kbd "C-c C-s") #'my/format-and-save-buffer)

;; ------------------------------
;; Other Tools
;; ------------------------------

(use-package magit)

(use-package vterm
  :hook (vterm-mode . (lambda ()
                        (setq-local scroll-up-aggressively 1)
                        (setq-local scroll-down-aggressively 1)))
  :config
  (setq vterm-shell "/bin/zsh"
        vterm-max-scrollback 10000))

(use-package all-the-icons)

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize))
  (exec-path-from-shell-copy-env "PATH"))

;; ------------------------------
(provide 'init)
;;; init.el ends here
