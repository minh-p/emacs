;; Useless modes
(menu-bar-mode 0)
(tool-bar-mode 0)

;; Debug
(setq debug-on-error t)

;; custom file so it doesn't pollute init.el
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

;; Backup-directory
(setq backup-directory-alist '(("." . "~/.config/emacs/backups")))

;; Melpa + Additional Packages Related Settings
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-install-upgrade-built-in t)
(package-initialize)

;; Fonts
(set-face-attribute 'default nil :family "Iosevka" :height 210)

;; Numbers Info
(column-number-mode 1)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

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

;; Project.el
(use-package project
  :ensure nil
  :bind (("C-x p C" . project-recompile)))

;; Code Formatter
(use-package apheleia
  :ensure t
  :init
  (apheleia-global-mode +1)
  )

;; Indentations
(setq-default c-basic-offset 4)

;; Eglot Hooks to Formatter
(use-package eglot
  :after treesit
  :preface
  (defun my/cs-offset ()
    (setq c-basic-offset 4))

  (defun my/cs-ts-offset ()
    (setq c-ts-mode-indent-offset 4))

  :ensure nil

  :hook
  ((c-mode . my/cs-offset)
   (c++-mode . my/cs-offset)
   (c-ts-mode . my/cs-ts-offset)
   (c++-ts-mode . my/cs-ts-offset))

  :config
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (add-hook 'before-save-hook
                        #'eglot-format-buffer nil t))))

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

;;; Better Searching (Consult)
(use-package consult
  :ensure t
  :bind (
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-bfuffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history)
	 )
  :init
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Improve finding code definitions
  (setq xref-show-xrefs-function #'consult-xref
	xref-show-definitions-function #'consult-xref)

  :config
  (setq consult-narrow-key "<")
  )

;; Consult-Eglot - Search LSP Workspace Symbols
(use-package consult-eglot
  :ensure t
  :bind (("M-s p" . consult-eglot-symbols)))

;; Embark - Extra actions instead of just opening
(use-package embark
  :ensure t
  :bind (
	 ("C-." . embark-act)
	 ("C-S-d" . embark-dwim)
	 ("C-h B" . embark-bindings)
	 )
  :init
  ;;; Key Help with a "completing-read" interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;;; Hide modeline of embark buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none))))
  )

(use-package embark-consult
  :ensure t)
