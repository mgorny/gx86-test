# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="A graphical and console tool for exploring the size of directories"
HOMEPAGE="http://guichaz.free.fr/pysize/"
SRC_URI="http://guichaz.free.fr/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="gtk ncurses"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	gtk? ( dev-python/pygtk:2 )
	ncurses? ( sys-libs/ncurses )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/psyco-${PV}-automagic.patch
	"${FILESDIR}"/${PV}-setuptools-automagic.patch
	)

DISTUTILS_NO_PARALLEL_BUILD=1

python_prepare_all() {
	if ! use gtk; then
		sed \
			-e '/^from pysize.ui.gtk/d' \
		    -e "s~'gtk': ui_gtk.run,~~g" \
		    -e 's:ui_gtk.run,::g' \
		    -i pysize/main.py || die "Failed to remove gtk support"
		rm -rf pysize/ui/gtk || die "Failed to remove gtk support"
	fi

	if ! use ncurses; then
		sed \
			-e '/^from pysize.ui.curses/d' \
		    -e "s~'curses': ui_curses.run,~~g" \
		    -e 's:ui_curses.run,::g' \
		    -i pysize/main.py || die "Failed to remove ncurses support"
		rm -rf pysize/ui/curses || die "Failed to remove ncurses support"
	fi

	sed \
		-e '/for ui_run in/s:ui_ascii.run:ui_ascii.run, ui_ascii.run:g' \
		-i pysize/main.py || die

	distutils-r1_python_prepare_all
}

src_test() {
	# Tests shatter otherwise
	local DISTUTILS_NO_PARALLEL_BUILD=1
	distutils-r1_src_test
}

python_test() {
	pushd "${S}"/tests > /dev/null
	PYTHONPATH=.:../ "${PYTHON}" pysize_tests.py || die "tests failed under ${EPYTHON}"
	popd  > /dev/null
}
