;;; dirvish.el --- A modern file manager based on dired mode -*- lexical-binding: t -*-
;; Copyright (C) 2021-2022 Alex Lu

;; Author : Alex Lu <https://github.com/alexluigit>
;; Version: 1.0.0
;; Keywords: files, convenience
;; Homepage: https://github.com/alexluigit/dirvish
;; SPDX-License-Identifier: GPL-3.0-or-later
;; Package-Requires: ((emacs "27.1"))

;;; Commentary:

;; `dirvish' is a minimalistic file manager based on `dired-mode'.  It is
;; inspired by ranger (see https://github.com/ranger/ranger), which is a
;; terminal file manager that shows a stack of the parent directories, and
;; updates its parent buffers while navigating the file system with an optional
;; preview window at side showing the content of the selected file.

;; Unlike `ranger.el', which tries to become an all-around emulation of ranger,
;; dirvish.el is more bare-bone, meaning it does NOT try to port all "goodness"
;; from ranger, instead, it tries to:
;;
;;   - provides a better Dired UI
;;   - make some Dired commands more intuitive
;;   - keep all your Dired key bindings
;;
;; The name `dirvish' is a tribute to `vim-dirvish'.

;;; Code:

(require 'dirvish-advices)

;;;###autoload
(define-minor-mode dirvish-override-dired-mode
  "Override Dired with `dirvish-dired' globally."
  :group 'dirvish :global t
  (if dirvish-override-dired-mode
      (progn
        (dirvish--add-advices)
        (setq find-directory-functions
              (cl-substitute #'dirvish--noselect #'dired-noselect find-directory-functions)))
    (dirvish--remove-advices)
    (setq find-directory-functions
          (cl-substitute #'dired-noselect #'dirvish--noselect find-directory-functions))))

;;;###autoload
(defun dirvish (&optional path)
  "Start a full frame Dirvish session with optional PATH.
If called with \\[universal-arguments], prompt for PATH,
otherwise it defaults to variable `buffer-file-name'."
  (interactive (list (and current-prefix-arg (read-file-name "Dirvish: "))))
  (dirvish-activate (dirvish-new :path (dirvish--ensure-path path) :depth dirvish-depth)))

;;;###autoload
(defun dirvish-dired (&optional path other-window)
  "Start a Dirvish session with optional PATH in current window.
If called with \\[universal-arguments], prompt for PATH,
otherwise it defaults to variable `buffer-file-name'.  Execute it
in other window when OTHER-WINDOW is non-nil."
  (interactive (list (and current-prefix-arg (read-file-name "Dirvish dired: ")) nil))
  (and other-window (switch-to-buffer-other-window dirvish-temp-buffer))
  (dirvish-activate (dirvish-new :path (dirvish--ensure-path path) :depth -1)))

(provide 'dirvish)
;;; dirvish.el ends here
