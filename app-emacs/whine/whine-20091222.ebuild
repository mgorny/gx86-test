# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit elisp

DESCRIPTION="Complaint generator for GNU Emacs"
HOMEPAGE="http://www.emacswiki.org/emacs/Whine"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

SITEFILE="50${PN}-gentoo.el"
