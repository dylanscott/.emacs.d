;; -*- lexical-binding: t -*-

;; Performance tweaking for modern machines
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Hide UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Better default modes
(setq mac-option-modifier 'meta)
(electric-pair-mode t)
(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
(save-place-mode t)
(savehist-mode t)
(recentf-mode t)
(global-auto-revert-mode t)

;; Better default settings
(require 'uniquify)
(require 'use-package-ensure)
(setq uniquify-buffer-name-style 'forward
      use-package-always-ensure t
      window-resize-pixelwise t
      frame-resize-pixelwise t
      load-prefer-newer t
      backup-by-copying t
      delete-by-moving-to-trash t
      dired-dwim-target t
      file-name-shadow-mode 1
      custom-file (expand-file-name "custom.el" user-emacs-directory))
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))

(use-package exec-path-from-shell
  :init (exec-path-from-shell-initialize))

(use-package savehist
  :config
  (savehist-mode))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package magit)

(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit)
         :map evil-insert-state-map
         ("C-k" . nil)
         ("C-." . nil))
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  :config
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "C-.") nil))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-spacegrey t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package olivetti
  :hook
  (org-mode . olivetti-mode))

(use-package vertico
  :custom
  (vertico-cycle t)
  (read-buffer-completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (completion-styles '(basic substring partial-completion flex))
  :hook
  ('rfn-eshadow-update-overlay . vertico-directory-tidy)
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous))
  :init
  (vertico-mode))

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  :init
  (global-corfu-mode))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  (setq consult-narrow-key "<"))

(use-package consult-project-extra)

(use-package consult-ls-git
  :bind
  (("C-c g f" . #'consult-ls-git)
   ("C-c g F" . #'consult-ls-git-other-window)))

(use-package consult-eglot)

(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("M-." . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc.  You may adjust the Eldoc
  ;; strategy, if you want to see the documentation from multiple providers.
  (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package eglot)

;; tree-sitter
(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (racket "https://github.com/6cdh/tree-sitter-racket")
     (rust "https://github.com/tree-sitter/tree-sitter-rust")
     (scheme "https://github.com/6cdh/tree-sitter-scheme")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (wasm "https://github.com/wasm-lsp/tree-sitter-wasm")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(use-package treesit-auto
  :config
  (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode))

(use-package clojure-mode
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.edn\\'" . clojure-mode))
  :init
  (add-hook 'clojure-mode-hook #'eldoc-mode)
  (add-hook 'clojure-mode-hook #'idle-highlight-mode))

(use-package geiser)
(use-package geiser-guile)

(use-package typescript-ts-mode
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode)))

(use-package lispy
  :hook (emacs-lisp-mode . lispy-mode))

(use-package lispyville
  :hook (lispy-mode . lispyville-mode)
  :config
  (lispyville-set-key-theme
   '(operators
     additional
     (additional-motions normal visual motion)
     text-objects
     prettify
     slurp/barf-lispy)))

(use-package general
  :config
  (general-auto-unbind-keys)
  (general-evil-setup t)

  ;; leader prefixed
  (general-create-definer leader
    :prefix "SPC")
  (leader
    :states '(motion normal visual)
    :keymaps 'override

    ;; map universal argument to SPC-u
    "u" '(universal-argument :which-key "Universal argument")

    ;; eval
    "e" '(:ignore t :which-key "eval")
    "eb" '(eval-buffer :which-key "eval-buffer")
    "ee" '(eval-expression :which-key "eval-expression")
    "ef" '(eval-defun :which-key "eval-defun")
    "es" '(eval-last-sexp :which-key "eval-last-sexp")

    ;; refactor
    "r" '(:ignore t :whick-key "refactor")
    "rn" '(eglot-rename :which-key "rename symbol")

    ;; consult
    "c" '(:ignore t :which-key "consult")
    "cb" '(consult-buffer :which-key "consult-buffer")
    "cp" '(consult-ls-git-ls-files :which-key "Find file in project")
    "cP" '(consult-ls-git-ls-files-other-window :which-key "Find file in project (other window)")
    "cm" '(consult-global-mark :which-key "consult-global-mark")
    "cM" '(consult-mark :which-key "consult-mark"))

   ;; normal mode
   (general-define-key
    :states '(normal visual)

    ;; nagivation
    "g" '(:ignore t :which-key "navigate"))

    ;; insert mode
   (general-define-key
    :states 'insert

    "C-SPC" 'completion-at-point
    "M-v" 'yank)

   (general-define-key
    :keymaps 'evil-ex-search-keymap
    "M-v" 'yank)

   (general-define-key
    "M-v" 'yank)

   ;; magit
   (general-define-key
    ;; https://github.com/emacs-evil/evil-magit/issues/14#issuecomment-626583736
    :keymaps 'transient-base-map
    "<escape>" 'transient-quit-one))
