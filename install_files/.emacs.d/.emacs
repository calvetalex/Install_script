;; ----------------------------------
;;           EPITECH CONFIG
;; ----------------------------------
(add-to-list 'load-path "~/.emacs.d/lisp")
(load "~/.emacs.d/epitech/std.el")
(load "~/.emacs.d/epitech/std_comment.el")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("2ae7611c5926f7d2cd84c2eb728978a29a8dc8254968136c9a78a78ad8ee086d" default)))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (docker python-x python-mode python-environment go-mode hl-todo auto-complete flycheck smooth-scrolling neotree))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;
;;Melpa
;;
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  ;;(add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;;
;;Theme
;;
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'my t)


;;
;;NeoTree
;;
(add-to-list 'load-path "/some/path/neotree")
  (require 'neotree)
  (global-set-key [f8] 'neotree-toggle)
  (setq neo-smart-open t)

;;
;;Flycheck
;;
(global-set-key [f5] 'global-flycheck-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)

;;
;;Norme Epitech
;;
(require 'whitespace)
 (setq whitespace-style
       (quote (face trailing tab-mark lines tail)))
       (add-hook 'find-file-hook 'whitespace-mode)

       (global-set-key (kbd "<f6>") 'whitespace-mode)
       (add-to-list 'load-path "~/.emacs.d/lisp")
       (global-set-key (kbd "<f7>") 'global-linum-mode)
       (global-linum-mode t)
       (setq column-number-mode t)
       (setq linum-format "%4d \u2502 ")

(electric-pair-mode 1)
(show-paren-mode 1)

;;
;;Spaces instead of Tabs
;;
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;;
;;Smooth Scrolling
;;
(require 'smooth-scrolling)
(smooth-scrolling-mode 1)

;;
;;Auto-Complete
;;
(ac-config-default)

;;
;;Highlight ToDo
;;
(global-hl-todo-mode 1)
(global-set-key (kbd "<f9>") 'hl-todo-mode)

;;stoperror
