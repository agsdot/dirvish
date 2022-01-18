;;; dirvish-diff.el --- Show diff in Dirvish preview window -*- lexical-binding: t -*-

;; Copyright (C) 2021-2022 Alex Lu
;; Author : Alex Lu <https://github.com/alexluigit>
;; Version: 0.9.7
;; Keywords: files, convenience
;; Homepage: https://github.com/alexluigit/dirvish
;; SPDX-License-Identifier: GPL-3.0-or-later
;; Package-Requires: ((emacs "27.1") (dirvish "0.9.9"))

;;; Commentary:

;; Show diff in Dirvish preview window.

;;; Code:

(require 'dirvish)

(defvar dirvish-diff-dispatchers
  '(dirvish-preview-disable-dispatcher
    dirvish-preview-directory-exa-dispatcher
    dirvish-vc-diff-dispatcher
    dirvish-preview-default-dispatcher))

(defun dirvish-vc-diff-dispatcher (_file _dv)
  "Doc."
  (when (cl-letf (((symbol-function 'pop-to-buffer) #'ignore)) (vc-diff))
    '(buffer . "*vc-diff*")))

;;;###autoload
(defun dirvish-diff (&optional path)
  "Doc."
  (interactive)
  (dirvish-here path
    :depth dirvish-depth
    :preview-dispatchers dirvish-diff-dispatchers))

(provide 'dirvish-diff)
;;; dirvish-diff.el ends here