# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=(python2_7)
inherit distutils-r1

DESCRIPTION="Python bindings for iptables"
HOMEPAGE="https://github.com/ldx/python-iptables"
SRC_URI="https://github.com/ldx/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-firewall/iptables"
RDEPEND="${DEPEND}"

# tests manipulate live iptables rules, so disable them by default
RESTRICT=test

PATCHES=(
	"${FILESDIR}/${PN}-0.2.0-tests.patch"
	"${FILESDIR}/${P}-conntrack-fixes.patch"
	"${FILESDIR}/${PN}-fix-ctypes.patch"
)

python_test() {
	${PYTHON} test.py || die "tests fail with ${EPYTHON}"
}
