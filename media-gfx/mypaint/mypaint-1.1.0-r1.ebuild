# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_DEPEND="2:2.5"

inherit eutils fdo-mime gnome2-utils multilib scons-utils toolchain-funcs python

DESCRIPTION="fast and easy graphics application for digital painters"
HOMEPAGE="http://mypaint.intilinux.com/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

LANGS="cs de en_CA en_GB es fr hu id it ja ko nb nn_NO pl pt_BR ro ru sl sv uk zh_CN zh_TW"
for x in ${LANGS}; do
	IUSE+="linguas_${x} "
done

RDEPEND="
	dev-python/pygtk:2
	dev-python/numpy
	>=dev-python/pycairo-1.4
	dev-libs/protobuf[python]
	>=dev-libs/json-c-0.11:=
	media-libs/lcms:2
	media-libs/libpng:0=
"
DEPEND="${RDEPEND}
	dev-lang/swig
	virtual/pkgconfig"

pkg_setup(){
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# multilib support
	sed -i -e "s:lib\/${PN}:$(get_libdir)\/${PN}:" \
		SConstruct SConscript || die
	# respect CXXFLAGS,CXX,LDFLAGS
	epatch "${FILESDIR}"/${P}-build-env-vars.patch
	# fix mypaint.desktop
	epatch "${FILESDIR}"/${P}-desktop.patch
	# pkgconfig patch for json-c-0.11. 467322
	epatch "${FILESDIR}"/${P}-json-c-0.11.patch
}

src_compile() {
	#workaround scons bug with locales. Bug #352700
	export LANG="en_US.UTF-8"
	tc-export CC CXX
	escons
}

src_install () {
	escons prefix="${D}/usr" install
	newicon pixmaps/${PN}_logo.png ${PN}.png
	for x in ${LANGS}; do
		if ! has ${x} ${LINGUAS}; then
			rm -rf "${ED}"/usr/share/locale/${x} || die
		fi
	done

	# not used and broken
	rm -rf "${ED}"/usr/{include/,lib/libmypaint.a,lib/pkgconfig/} || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	python_mod_optimize /usr/share/${PN}
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	python_mod_cleanup /usr/share/${PN}
}
