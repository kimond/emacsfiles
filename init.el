;;; kimond/emacsfile ----- My emacs config
(require 'cl)
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-verbose t)
(require 'use-package)

;; Package list
(defvar kimond/packages '(magit
			  company
			  anzu
			  markdown-mode
			  web-mode
			  js2-mode
			  evil
			  powerline
			  flycheck
			  spaceline
			  jbeans-theme)
  "Default packages")


(defun kimond/packages-installed-p ()
  (loop for pkg in kimond/packages
	when (not (package-installed-p pkg)) do (return nil)
	finally (return t)))

(unless (kimond/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg kimond/packages)
    (when (not (package-installed-p pkg))
            (package-install pkg))))

;; Config
(setq make-backup-files nil)

(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)
(show-paren-mode t)


(add-hook 'find-file-hook (lambda () (linum-mode 1)))
(setq linum-format "%4d \u2502 ") ;; set solid line after line number

;; Load theme
(load-theme 'jbeans t)

;; Anzu
(global-anzu-mode +1)

;; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

;; Enable mouse support
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] (lambda ()
			      (interactive)
			      (scroll-down 1)))
  (global-set-key [mouse-5] (lambda ()
			      (interactive)
			      (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
  )

;; evil
(require 'evil)
(evil-mode 1)

(require 'powerline)
(powerline-vim-theme)

;; Spaceline config
(require 'spaceline-config)
(spaceline-spacemacs-theme)
(setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

;; Js2-mode
(add-to-list 'auto-mode-alist '("\\.js\\'\\|\\.json\\'" . js2-mode))

;; company
(use-package company
    :ensure t
    :config
    (add-hook 'prog-mode-hook 'company-mode))
