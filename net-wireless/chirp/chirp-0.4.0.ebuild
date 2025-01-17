# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python2_7 )

if [[ ${PV} == "9999" ]] ; then
	SCM=mercurial
	EHG_REPO_URI="http://d-rats.com/hg/chirp.hg"
fi

inherit distutils-r1 ${SCM}

DESCRIPTION="Free open-source tool for programming your amateur radio"
HOMEPAGE="http://chirp.danplanet.com"

if [[ ${PV} == "9999" ]] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="http://chirp.danplanet.com/download/${PV}/${P}.tar.gz"
fi
LICENSE="GPL-3"
SLOT="0"
IUSE=""
RESTRICT=test

DEPEND="dev-python/pyserial
	dev-libs/libxml2[python]"
RDEPEND="${DEPEND}
	dev-python/pygtk"

src_prepare() {
	sed -i -e "/share\/doc\/chirp/d" setup.py || die
	distutils-r1_src_prepare
}
