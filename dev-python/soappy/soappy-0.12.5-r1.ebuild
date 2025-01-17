# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"
PYTHON_DEPEND="2"
PYTHON_USE_WITH="ssl(+)? xml(+)"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_PN="SOAPpy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="SOAP Services for Python"
HOMEPAGE="http://pywebsvcs.sourceforge.net/ http://pypi.python.org/pypi/SOAPpy"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-macos"
IUSE="examples ssl"

RDEPEND="dev-python/fpconst
	dev-python/wstools
	ssl? ( dev-python/m2crypto )"
DEPEND="${RDEPEND}
	dev-python/setuptools"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES.txt README.txt docs/*"
PYTHON_MODNAME="${MY_PN}"

src_prepare() {
	distutils_src_prepare
	find -name .cvsignore -print0 | xargs -0 rm -f
}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r bid contrib tools validate
	fi
}
