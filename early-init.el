;;; early-init.el --- Optimize startup speed

(setq package-enable-at-startup nil)
(setq package--init-file-ensured t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(setq frame-inhibit-implied-resize t)
(setq inhibit-startup-screen t)
(setq load-prefer-newer t
      inhibit-default-init t)

(defvar default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 50 1000 1000)
                  gc-cons-percentage 0.1
                  file-name-handler-alist default-file-name-handler-alist)))

(provide 'early-init)
;;; early-init.el ends here
