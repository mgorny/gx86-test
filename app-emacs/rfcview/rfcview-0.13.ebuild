# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit elisp

DESCRIPTION="An Emacs mode that reformats IETF RFCs for display"
HOMEPAGE="http://www.loveshack.ukfsn.org/emacs/
	http://www.emacswiki.org/emacs-de/RfcView"
# taken from http://www.loveshack.ukfsn.org/emacs/${PN}.el
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 x86"

SITEFILE="50${PN}-gentoo.el"
