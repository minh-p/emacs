;; Useless modes
(menu-bar-mode 0)
(tool-bar-mode 0)

;; Debug
(setq debug-on-error t)

;; custom file so it doesn't pollute init.el
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

;; Melpa + Additional Packages Related Settings
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-install-upgrade-built-in t)
(package-initialize)

;; Fonts
(set-face-attribute 'default nil :family "Iosevka" :height 210)

;; Theme
(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox t)
  )

;; Direnv
(use-package direnv
  :ensure t
  :config
  (direnv-mode))

;; Org configuration
(use-package org
  :ensure nil
  :hook (org-mode . org-indent-mode) (org-mode . visual-line-mode))

;; Org-roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/org-roam"))
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert)
	 ("C-c n c" . org-roam-capture)
	 ("C-c n r d" . org-roam-dailies-find-date))
  :config
  (org-roam-db-autosync-mode)
)


(use-package org-superstar
  :ensure t
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-special-todo-items t)
  (org-superstar-remove-leading-stars t)
  :custom-face  
  (org-level-1 ((t (:inherit outline-1 :height 1.5))))
  (org-level-1 ((t (:inherit outline-1 :height 1.3))))
  (org-level-2 ((t (:inherit outline-2 :height 1.2))))
  (org-level-3 ((t (:inherit outline-3 :height 1.1))))
  (org-level-4 ((t (:inherit outline-4 :height 1.0))))
  (org-level-5 ((t (:inherit outline-5 :height 1.0))))
  )

;; Magit

(use-package transient :ensure t)
(use-package magit
  :ensure t
  :config
  (keymap-global-set "C-c g g" 'magit-status)
  :after transient)

;; Treesit Langs Better Syntax Highlighting
(use-package treesit
  :ensure nil
  :init
  (add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-mode))
  (add-to-list 'auto-mode-alist '("\\.cmake\\'" . cmake-mode))
  :config
  (setq treesit-extra-load-path '("~/.config/emacs/tree-sitter"))
  (setq treesit-language-source-alist
	'((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
          (c    . ("https://github.com/tree-sitter/tree-sitter-c"))
          (cpp  . ("https://github.com/tree-sitter/tree-sitter-cpp"))
          (cmake . ("https://github.com/uyha/tree-sitter-cmake"))
          (nix  . ("https://github.com/nix-community/tree-sitter-nix"))
	  (qmljs . ("https://github.com/yuja/tree-sitter-qmljs.git"))))
  (setq major-mode-remap-alist '((sh-mode . bash-ts-mode)
				 (c-mode . c-ts-mode)
				 (c++-mode . c++-ts-mode)
				 (cmake-mode . cmake-ts-mode)))
  )

;; Treesit Modes Not Built-in
(use-package nix-ts-mode
  :ensure t
  :after treesit
  :mode "\\.nix\\'")

(use-package qml-ts-mode
  :vc (:url "https://github.com/xhcoding/qml-ts-mode" :rev :newest)
  :mode "\\.qml\\'")

;; Terminal: Vterm
(use-package vterm
  :ensure t)

;; ;; Evil Mode and Evil Collections
;; (use-package evil
;;   :init
;;   (setq evil-want-integration t
;;         evil-want-keybinding nil
;;         evil-want-C-u-scroll t
;;         evil-want-Y-yank-to-eol t
;;         evil-respect-visual-line-mode t
;;         evil-undo-system 'undo-redo)
;;   :config
;;   (evil-mode 1))

;; (use-package evil-collection
;;   :after evil
;;   :ensure t
;;   :init
;;   (setq evil-want-integration t evil-want-keybinding nil)
;;   :config
;;   (evil-collection-init))

;; MiniBuffer
;;; Vertico (Vertical Display) and Orderless Search (Fuzzy Finder)
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  ;; Makes orderless treat component queries as fuzzy flex matches
  (orderless-matching-styles '(orderless-flex))) 

;;; Marginalia (Annotations)
(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode)
  )

;;; Nerd Fonts Icons
(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)
  )

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode)
  :ensure t)
