# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit kde4-base multilib

DESCRIPTION="Advanced Kolab Object Handling Library"
HOMEPAGE="http://kolab.org"
SRC_URI="http://mirror.kolabsys.com/pub/releases/${P}.tar.gz"

LICENSE="LGPL-2+ LGPL-2.1+ LGPL-3+"
SLOT="4"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="php python test"

# Tests fail, last checked 0.4.1
RESTRICT="test"

DEPEND="
	$(add_kdebase_dep kdepimlibs 'semantic-desktop(+)')
	dev-lang/swig
	>=net-libs/libkolabxml-0.7.0
	php? ( dev-lang/php )
	python? ( dev-lang/python )

"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR=$(get_libdir)
		$(cmake-utils_use_with test BUILD_TESTS)
		$(cmake-utils_use python PYTHON_BINDINGS)
		$(cmake-utils_use php PHP_BINDINGS)
	)
	kde4-base_src_configure
}
