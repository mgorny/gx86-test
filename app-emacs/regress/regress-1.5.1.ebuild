# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit elisp

DESCRIPTION="Regression test harness for Emacs Lisp code"
HOMEPAGE="http://www.emacswiki.org/cgi-bin/wiki/WikifiedEmacsLispList"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"

ELISP_PATCHES="${PV}-regress.el-gentoo.patch"
SITEFILE="50${PN}-gentoo.el"
