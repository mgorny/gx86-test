# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit games cmake-utils bash-completion-r1

DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="http://www.flightgear.org/"
SRC_URI="mirror://flightgear/Source/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dbus debug examples jpeg +jsbsim oldfdm test +udev +utils vim-syntax +yasim"

COMMON_DEPEND="
	dev-db/sqlite:3
	>=dev-games/openscenegraph-3.0.1[png]
	~dev-games/simgear-${PV}[jpeg?]
	media-libs/openal
	sys-libs/zlib
	x11-libs/libX11
	dbus? ( >=sys-apps/dbus-1.6.18-r1 )
	udev? ( virtual/udev )
	utils? (
		media-libs/freeglut
		media-libs/libpng
		virtual/opengl
	)
"
# Some entries below are just buildsystem bugs (jpeg) or
# deps unconditionally inherited from static version of simgear
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.44
	>=media-libs/plib-1.8.5
	jpeg? ( virtual/jpeg )
"
RDEPEND="${COMMON_DEPEND}
	~games-simulation/${PN}-data-${PV}
"

DOCS=(AUTHORS ChangeLog NEWS README Thanks)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
		-DENABLE_FGADMIN=OFF
		-DENABLE_PROFILE=OFF
		-DENABLE_RTI=OFF
		-DFG_DATA_DIR="${GAMES_DATADIR}"/${PN}
		-DSIMGEAR_SHARED=ON
		-DSP_FDMS=OFF
		-DSYSTEM_SQLITE=ON
		$(cmake-utils_use_use dbus)
		$(cmake-utils_use jpeg JPEG_FACTORY)
		$(cmake-utils_use_enable jsbsim)
		$(cmake-utils_use_enable oldfdm LARCSIM)
		$(cmake-utils_use_enable oldfdm UIUC_MODEL)
		$(cmake-utils_use test LOGGING)
		$(cmake-utils_use_enable test TESTS)
		$(cmake-utils_use udev EVENT_INPUT)
		$(cmake-utils_use_enable utils FGCOM)
		$(cmake-utils_use_enable utils FGELEV)
		$(cmake-utils_use_enable utils FGJS)
		$(cmake-utils_use_with utils FGPANEL)
		$(cmake-utils_use_enable utils FGVIEWER)
		$(cmake-utils_use_enable utils GPSSMOOTH)
		$(cmake-utils_use_enable utils JS_DEMO)
		$(cmake-utils_use_enable utils METAR)
		$(cmake-utils_use_enable utils TERRASYNC)
		$(cmake-utils_use_enable yasim)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# Install icons and menu entry
	local s
	for s in 16 22 24 32 48 64 128; do
		doicon -s ${s} icons/${s}x${s}/apps/${PN}.png
		use utils && doicon -s ${s} icons/${s}x${s}/apps/fgcom.png
	done
	doicon -s scalable icons/scalable/${PN}.svg
	use utils && doicon -s scalable icons/scalable/fgcom.svg

	newmenu package/${PN}.desktop ${PN}.desktop

	# Install bash completion (TODO zsh)
	# Uncomment below when scripts stops writing files...
#	sed -e "s|/usr/local/share/FlightGear|${GAMES_DATADIR}/${PN}|" \
#		-i scripts/completion/fg-completion.bash || die 'unable to replace FG_ROOT'
#	newbashcomp scripts/completion/fg-completion.bash ${PN}

	# Install examples and other misc files
	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins -r scripts/java scripts/perl scripts/python
		insinto /usr/share/doc/"${PF}"/examples/c++
		doins -r scripts/example/*
		insinto /usr/share/doc/"${PF}"/tools
		doins -r scripts/atis scripts/tools/*
	fi

	# Install nasal script syntax
	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins scripts/syntax/{ac3d,nasal}.vim
		insinto /usr/share/vim/vimfiles/ftdetect/
		doins "${FILESDIR}"/{ac3d,nasal}.vim
	fi

	prepgamesdirs
}
