;;; sb-nikkei.el --- shimbun backend for nikkei.co.jp

;; Copyright (C) 2001, 2002
;; Kazuyoshi KOREEDA <Kazuyoshi.Koreeda@rdmg.mgcs.mei.co.jp>

;; Author: Kazuyoshi KOREEDA <Kazuyoshi.Koreeda@rdmg.mgcs.mei.co.jp>
;; Keywords: news

;; This file is a part of shimbun.

;; This program is free software; you can redistribute it a>nd/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, you can either send email to this
;; program's maintainer or write to: The Free Software Foundation,
;; Inc.; 59 Temple Place, Suite 330; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Original code was sb-asahi.el which is written by
;; TSUCHIYA Masatoshi <tsuchiya@namazu.org> and
;; Yuuichi Teranishi <teranisi@gohome.org>.

;;; Code:

(require 'shimbun)
(require 'sb-text)

(luna-define-class shimbun-nikkei (shimbun shimbun-text) ())

(defvar shimbun-nikkei-url "http://www.nikkei.co.jp/news/")

(defvar shimbun-nikkei-groups '("keizai" "seiji" "kaigai" "market" "sangyo" "tento" "shakai" "retto" "shasetsu" "zinzi" "okuyami"))

(defvar shimbun-nikkei-from-address "webmaster@nikkei.co.jp")
(defvar shimbun-nikkei-content-start "<!--FJZONE START NAME=\"HONBUN\" -->")
(defvar shimbun-nikkei-content-end   "<!--FJZONE END NAME=\"HONBUN\" -->")
(defvar shimbun-nikkei-x-face-alist
  '(("default" . "X-Face: Ygq$6P.,%Xt$U)DS)cRY@k$VkW\
!7(X'X'?U{{osjjFG\"E]hND;SPJ-J?O?R|a?Lg2$0rVng\n =O3\
Lt}?~IId8Jj&vP^3*o=LKUyk(`t%0c!;t6REk=JbpsEn9MrN7gZ%")))
(defvar shimbun-nikkei-expiration-days 7)

(luna-define-method shimbun-index-url ((shimbun shimbun-nikkei))
  (format "%s%s/index.html"
	  (shimbun-url-internal shimbun)
	  (shimbun-current-group-internal shimbun)))

(luna-define-method shimbun-get-headers ((shimbun shimbun-nikkei)
					 &optional range)
  (let ((from (shimbun-from-address-internal shimbun))
	(group (shimbun-current-group-internal shimbun))
	(parent (shimbun-url-internal shimbun))
	(case-fold-search t)
	basename headers)
    (goto-char (point-min))
    (while (re-search-forward
	    "<!-- aLink --><\\(!-- \\)?a href=\"\\(.+\\)\\.html"
	    nil t)
      (setq basename (match-string 2))
      (when (re-search-forward
	     "<!-- headline -->\\(.+\\)<!-- /headline -->"
	     nil t)
	(push (shimbun-make-header
	       0
	       (shimbun-mime-encode-string (match-string 1))
	       from
	       ""
	       (concat "<" basename "@" group ">")
	       ""
	       0
	       0
	       (concat parent group "/" basename ".html"))
	      headers)))
    headers))

(provide 'sb-nikkei)

;;; sb-nikkei.el ends here.
