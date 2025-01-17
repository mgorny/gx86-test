# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit elisp

DESCRIPTION="An Emacs mode which highlights every even line with an alternative background color"
HOMEPAGE="http://www.emacswiki.org/cgi-bin/wiki/StripesMode"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 x86"

SITEFILE="50${PN}-gentoo.el"
