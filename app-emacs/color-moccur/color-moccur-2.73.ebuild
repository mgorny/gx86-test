# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit elisp

DESCRIPTION="Major mode for color moccur"
HOMEPAGE="http://www.bookshelf.jp/
	http://www.emacswiki.org/cgi-bin/wiki/SearchBuffers"
# taken from http://www.bookshelf.jp/elc/color-moccur.el
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
