# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )
PYTHON_REQ_USE="threads"
PYTHON_MODNAME="${PN}lib"
MY_P="${PN}_${PV}.orig"

inherit eutils distutils-r1

DESCRIPTION="A backup program that supports encryption and deduplication"
HOMEPAGE="http://obnam.org/"
SRC_URI="http://code.liw.fi/debian/pool/main/o/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-python/cliapp
	dev-python/fuse-python
	dev-python/larch
	!=dev-python/paramiko-1.13.0
	|| ( <dev-python/paramiko-1.13.0 >dev-python/paramiko-1.13.0 )
	dev-python/tracing
	dev-python/ttystatus
	"
RDEPEND="${DEPEND}"

PATCHES=( )

src_compile() {
	addwrite /proc/self/comm
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	find "${D}" -name "obnam-viewprof*" -delete
	insinto /etc
	doins "${FILESDIR}"/obnam.conf
	keepdir /var/log/obnam
}

pkg_postinst() {
	if [[ $REPLACING_VERSIONS < "1.2" ]]; then
		elog "You will need to setup a config file before running obnam for the first time."
		elog "For details, please see the obnam(1) manual page."
		elog "An example file has been installed as /etc/obnam.conf for your convenience."
	fi
}
