# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )
inherit autotools python-r1 base

DESCRIPTION="KDE frontend to Anyremote"
HOMEPAGE="http://anyremote.sourceforge.net/"
SRC_URI="mirror://sourceforge/anyremote/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="bluetooth"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=app-mobilephone/anyremote-6.0[bluetooth?]
	dev-python/PyQt4[X,${PYTHON_USEDEP}]
	kde-base/pykde4:4[${PYTHON_USEDEP}]
	bluetooth? ( dev-python/pybluez[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_prepare() {
	# using gettextize no-interactive example from dev-util/bless package
	cp $(type -p gettextize) "${T}"/
	sed -i -e 's:read dummy < /dev/tty::' "${T}/gettextize"
	"${T}"/gettextize -f --no-changelog > /dev/null

	# remove deprecated entry
	sed -e "/Encoding=UTF-8/d" \
		-i kanyremote.desktop || die "fixing .desktop file failed"

	# fix documentation directory wrt bug #316087
	sed -i "s/doc\/${PN}/doc\/${PF}/g" Makefile.am
	eautoreconf

	# disable bluetooth check to avoid errors
	if ! use bluetooth ; then
		sed -e "s/usepybluez    = True/usepybluez    = False/" -i kanyremote || die
	fi
}

src_install() {
	default

	python_replicate_script "${D}"/usr/bin/kanyremote
}
