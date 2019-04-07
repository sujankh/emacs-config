;;; init --- Custom init for C++/Python
;;; Commentary: skhadka

(require 'package)
(add-to-list 'package-archives
         '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(add-to-list 'load-path "~/.emacs.d/custom/")

;; use-package is the best emacs plugin
(require 'use-package)
(setq use-package-always-ensure t)

; refresh buffers if the file changes
(global-auto-revert-mode t)

(add-hook 'gud-mode-hook 'my-gud-hook)
(defun my-gud-hook ()
  (company-mode -1))

;; Sidebar
(use-package sr-speedbar
  :ensure t
  :config
  (sr-speedbar-open)
  (custom-set-variables
   '(speedbar-show-unknown-files t))
  )

; delete whitespace from end of lines
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;Smooth scroll
(use-package smooth-scrolling
  :ensure t
  :init
  (setq smooth-scrolling-mode 1))

;;; All modes
(use-package cuda-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.cu\\'" . cuda-mode))
)

(use-package bazel-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("BUILD" . bazel-mode))
)

(use-package go-mode
  :ensure t)


;;; Switch between .hh and .cc files
(add-hook 'c-mode-common-hook
          (lambda()
            (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

;; Set line max length
(setq column-enforce-column 121)
;;(global-column-enforce-mode)

;;ycmd

(use-package company
  :ensure t
  )

(use-package company-ycmd
  :ensure t
  :config
  (company-ycmd-setup)
  )

;; Refer to https://github.com/sujankh/emacs-ycmd-linuxkernel for guide to build/install ycmd
(use-package ycmd
  :ensure t
)

(add-hook 'after-init-hook #'global-ycmd-mode)
(set-variable 'ycmd-server-command `("python3",  (file-truename  "/home/skhadka/tools/ycmd/ycmd")))
(set-variable 'ycmd-extra-conf-handler 'load)
(setq company-idle-delay 0.2)
(eval-after-load 'cc-mode '(define-key c-mode-base-map (kbd "M-.") (function ycmd-goto)))


(use-package flycheck-ycmd
  :ensure t
  :config
  (flycheck-ycmd-setup)
  (global-flycheck-mode)
  )
;; Company and flycheck can interfere in emacs -nw.
(when (not (display-graphic-p))
    (setq flycheck-indication-mode nil))

(global-ycmd-mode)

;; elpy
;; Make sure to install dependencies from https://github.com/jorgenschaefer/elpy
;; Also checkout M-x elpy-config to make sure all dependencies are set
(use-package elpy
  :ensure t
  :config
  (elpy-enable)
  )

;;Frames jump
(global-set-key [S-left] 'windmove-left)          ; move to left window
(global-set-key [S-right] 'windmove-right)        ; move to right window
(global-set-key [S-up] 'windmove-up)              ; move to upper window
(global-set-key [S-down] 'windmove-down)          ; move to lower window


;; YAML mode
(use-package yaml-mode
  :ensure t
  )
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))


;; Easy C-x f
(use-package textmate
  :init (textmate-mode))

;; fzf fuzzy finder
;; Only want to search through git files by default
;; NOTE: Install fzf on your system for this plugin to work

(use-package fzf
  :ensure t)
(global-set-key (kbd "C-x p") 'fzf-git-files)
(global-set-key (kbd "C-x f") 'fzf-git-files)

;; Git integration
(use-package magit
  :ensure t)

;;;; GLOBAL Settings
;;Line number
(global-linum-mode t)

;; ZenBURRN
;;(load-theme 'zenburn t)
;; Jelly Beans
(use-package jbeans-theme
  :ensure t
  :config
  (load-theme 'jbeans t))

;; All those backup files #filename# should be stored outside of the tree
(setq backup-directory-alist
      `((".*" . ,(concat user-emacs-directory "backups"))))
(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "backups"))))

(global-hl-line-mode t)
;; Disable the toolbar at the top since it's useless
(if (functionp 'tool-bar-mode) (tool-bar-mode -1))

;; Code Folding
;;(global-set-key (kbd "C-c C-f") 'fold-this-all)
(global-set-key (kbd "C-c C-f") 'fold-this)
(global-set-key (kbd "C-c M-f") 'fold-this-unfold-all)

;; Show paren mode
(show-paren-mode 1)
(setq show-paren-delay 0)


;;
(use-package flymd
  :ensure t
  :config
  (defun my-flymd-browser-function (url)
    (let ((browse-url-browser-function 'browse-url-firefox))
      (browse-url url)))
  (setq flymd-browser-open-function 'my-flymd-browser-function)
  )

;;--- Assembly packages---

;; Similar to godbolt
(use-package rmsbolt
  :ensure t)

;; Make sure intel manual is downloaded at ~/intel
(use-package x86-lookup
  :ensure t
  :init
  (bind-key "C-h x" 'x86-lookup)
  :custom
  (x86-lookup-pdf "~/intel/manual_all_volumes.pdf"))
