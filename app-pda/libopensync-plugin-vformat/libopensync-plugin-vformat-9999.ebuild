# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"

inherit cmake-utils subversion

DESCRIPTION="OpenSync VFormat Plugin"
HOMEPAGE="http://www.opensync.org"
SRC_URI=""

ESVN_REPO_URI="http://svn.opensync.org/format-plugins/vformat/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="~app-pda/libopensync-${PV}
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

# Don't pass
RESTRICT="test"

DOCS="AUTHORS"
