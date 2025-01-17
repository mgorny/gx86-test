# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="An LDAP database backend for Django"
HOMEPAGE="https://github.com/jlaine/django-ldapdb"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="test"
LICENSE="MIT"
SLOT="0"

RDEPEND="dev-python/django[${PYTHON_USEDEP}]
	>=dev-python/python-ldap-2.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
