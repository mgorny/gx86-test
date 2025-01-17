# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Client library for Rackspace Cloud Monitoring"
HOMEPAGE="https://github.com/racker/rackspace-monitoring"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

TEST_DEPENDS="dev-python/mock[${PYTHON_USEDEP}]
			dev-python/pep8[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/libcloud-0.14.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( ${TEST_DEPENDS}
				${RDEPEND} )"
python_test() {
	${EPYTHON} setup.py test || die
}
