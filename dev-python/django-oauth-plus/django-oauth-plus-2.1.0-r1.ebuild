# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Support of OAuth 1.0a in Django using python-oauth2"
HOMEPAGE="http://pypi.python.org/pypi/django-oauth-plus	http://code.welldev.org/django-oauth-plus/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/django-1.2.4[${PYTHON_USEDEP}]
	>=dev-python/oauth2-1.5.170[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_hg[${PYTHON_USEDEP}]"

python_test() {
	if "${PYTHON}" oauth_provider/runtests/manage.py test; then
		einfo "Testsuite passed under ${EPYTHON}"
	else
		die "Testsuite failed under ${EPYTHON}"
	fi
}
