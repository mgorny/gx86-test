# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python2_6 python2_7 )

inherit distutils-r1

DESCRIPTION="Disk Config extension for python-novaclient"
HOMEPAGE="https://github.com/rackspace/os_diskconfig_python_novaclient_ext"
SRC_URI="mirror://pypi/${PN:0:1}/os_diskconfig_python_novaclient_ext/os_diskconfig_python_novaclient_ext-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/os_diskconfig_python_novaclient_ext-${PV}"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/python-novaclient-2.10.0[${PYTHON_USEDEP}]"
