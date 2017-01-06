;; Winter Fu Emacs configure file
;; Date 2014-03-09
;; Author Winter Fu
;; Github user.email = "winterfu@gmail.com"


;; User details
(setq user-full-name "Winter Fu")
(setq user-email-address "winterfu@gmail.com")


;; Emacs package manager, Add source into package-archives
(require 'package)
;;original source before merage to gnu
;;("elpa" . "http://tromey.com/elpa/")
(dolist (source '(("gnu" . "http://elpa.gnu.org/packages/")
		  ("melpa" . "https://melpa.org/packages/")
		  ;;("melpa-stable" . "https://stable.melpa.org/packages/")
		  ("marmalade" . "https://marmalade-repo.org/packages/")
		  ))
  (add-to-list 'package-archives source t))
;; Change defaut `package-user-dir' to "~/.emacs.d/packages"
(setq package-user-dir "~/.emacs.d/packages")
(package-initialize)

;; Add `load-path' from ~/.emacs.d
;; Add all user libs and user site-lisp to begin of the `load-path'
(defun push-user-lisp-to-load-path (dir)
  "Push user elisp to load-path"
  (let ((default-directory (file-name-as-directory dir)))
    (setq load-path
	  (append
	   (let ((load-path (copy-sequence load-path)))
	     (append 
	      (copy-sequence (normal-top-level-add-to-load-path '(".")))
	      (normal-top-level-add-subdirs-to-load-path)))
	   load-path)))
  )

(defun add-subdirs-to-load-path (dir)
  "Recursive add directories to `load-path'."
  (let ((default-directory (file-name-as-directory dir)))
    (normal-top-level-add-to-load-path '("."))
    (normal-top-level-add-subdirs-to-load-path))
  )

;; Push configuration first then push packages, reverse the sequence
(push-user-lisp-to-load-path "~/.emacs.d/site-lisp")
(push-user-lisp-to-load-path "~/.emacs.d/packages")


;; Startup initializaion. For windows system.

(if (display-graphic-p)
    (progn
      (tool-bar-mode -1)
      (menu-bar-mode -1)
      (scroll-bar-mode -1)))

(require 'whitespace)
(setq whitespace-line-column 100) ;; limit line length
(setq whitespace-style '(face lines-tail))

(add-hook 'prog-mode-hook 'whitespace-mode)

;; Windows size and position
(add-to-list 'default-frame-alist '(width . 192))
(add-to-list 'default-frame-alist '(height . 48))

;; initial tab mode for default
(setq tab-width 2
      indent-tabs-mode nil)


;; Autosave
;; Save buffer to original file automatically,
;; and C-x, C-s make versioned backup
;; Save all tempfiles in $TMPDIR/emacs$UID/
(defconst emacs-tmp-dir
  (format "%s%s%s/" "~/.emacs.d/tmp/" "emacs" (user-uid)))

(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)

(defun full-auto-save ()
  (interactive)
  (save-excursion
    (dolist (buf (buffer-list))
      (set-buffer buf)
      (if (and (buffer-file-name) (buffer-modified-p))
	  (basic-save-buffer)))))

(add-hook 'auto-save-hook 'full-auto-save)
(if (boundp 'focus-out-hook)
    (add-hook 'focus-out-hook 'save-all)
  )


;; Backup
;; revert versioned file for C-x, C-s
(defconst emacs-backup-dir
  (format "%s%s%s/" "~/.emacs.d/backup/" "emacs" (user-uid)))

(setq backup-directory-alist
      `((".*" . ,emacs-backup-dir)))

;; turn off tramp backup
(add-to-list 'backup-directory-alist
             (cons tramp-file-name-regexp nil))

(setq make-backup-files t)
(setq kept-old-versions 10)
(setq kept-new-versions 20)
(setq delete-old-versions t)
(setq backup-by-copying t)
(setq version-control t)
