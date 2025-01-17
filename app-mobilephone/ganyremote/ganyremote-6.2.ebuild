# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit base eutils

DESCRIPTION="Gnome frontend to Anyremote"
HOMEPAGE="http://anyremote.sourceforge.net/"
SRC_URI="mirror://sourceforge/anyremote/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth"

DEPEND=">=app-mobilephone/anyremote-6.0[bluetooth=]
	dev-python/pygtk
	bluetooth? ( dev-python/pybluez )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )
