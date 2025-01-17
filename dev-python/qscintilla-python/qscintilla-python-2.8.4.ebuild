# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit python-r1 qmake-utils

MY_P=QScintilla-gpl-${PV}

DESCRIPTION="Python bindings for Qscintilla"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/qscintilla/intro"
SRC_URI="mirror://sourceforge/pyqt/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

DEPEND="
	${PYTHON_DEPS}
	>=dev-python/sip-4.16:=[${PYTHON_USEDEP}]
	>=dev-python/PyQt4-4.11[X,${PYTHON_USEDEP}]
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	~x11-libs/qscintilla-${PV}:=
"
RDEPEND="${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${MY_P}/Python

src_prepare() {
	python_copy_sources
}

src_configure() {
	configuration() {
		local myconf=(
			"${PYTHON}" configure.py
			--destdir="$(python_get_sitedir)"/PyQt4
			--pyqt=PyQt4
			--sip-incdir="$(python_get_includedir)"
			--pyqt-sipdir="${EPREFIX}"/usr/share/sip
			--qsci-sipdir="${EPREFIX}"/usr/share/sip
			$(use debug && echo --debug)
			--no-timestamp
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		# Run eqmake4 to respect toolchain, build flags, and prevent stripping
		eqmake4
	}
	python_parallel_foreach_impl run_in_build_dir configuration
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		emake INSTALL_ROOT="${D}" install
		python_optimize
	}
	python_foreach_impl run_in_build_dir installation
}
