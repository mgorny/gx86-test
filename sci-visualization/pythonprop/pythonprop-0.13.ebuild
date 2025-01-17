# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Scripts to prepare and plot VOACAP propagation predictions"
HOMEPAGE="http://www.qsl.net/hz1jw/pythonprop"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-electronics/voacapl
	dev-python/matplotlib[gtk]
	dev-python/basemap"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS TODO
}
