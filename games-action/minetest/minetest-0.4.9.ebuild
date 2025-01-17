# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit eutils cmake-utils gnome2-utils vcs-snapshot user games

DESCRIPTION="An InfiniMiner/Minecraft inspired game"
HOMEPAGE="http://minetest.net/"
SRC_URI="http://github.com/minetest/minetest/tarball/${PV} -> ${P}.tar.gz"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+curl dedicated leveldb luajit nls +server +sound +truetype"

RDEPEND="dev-db/sqlite:3
	>=dev-games/irrlicht-1.8-r2
	sys-libs/zlib
	curl? ( net-misc/curl )
	!dedicated? (
		app-arch/bzip2
		media-libs/libpng:0
		virtual/jpeg
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXxf86vm
		sound? (
			media-libs/libogg
			media-libs/libvorbis
			media-libs/openal
		)
		truetype? ( media-libs/freetype:2 )
	)
	leveldb? ( dev-libs/leveldb )
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1.4[deprecated] )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

pkg_setup() {
	games_pkg_setup

	if use server || use dedicated ; then
		enewuser ${PN} -1 -1 /var/lib/${PN} ${GAMES_GROUP}
	fi
}

src_unpack() {
	vcs-snapshot_src_unpack
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-lua-luajit-option.patch \
		"${FILESDIR}"/${P}-shared-irrlicht.patch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-opengles.patch \
		"${FILESDIR}"/${P}-freetype.patch

	# correct gettext behavior
	if [[ -n "${LINGUAS+x}" ]] ; then
		for i in $(cd po ; echo *) ; do
			if ! has ${i} ${LINGUAS} ; then
				rm -r po/${i} || die
			fi
		done
	fi

	# jthread is modified
	# json is modified
	rm -r src/{lua,sqlite} || die

	# set paths
	sed \
		-e "s#@BINDIR@#${GAMES_BINDIR}#g" \
		-e "s#@GROUP@#${GAMES_GROUP}#g" \
		"${FILESDIR}"/minetestserver.confd > "${T}"/minetestserver.confd || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_GLES2=0
		-DRUN_IN_PLACE=0
		-DCUSTOM_SHAREDIR="${GAMES_DATADIR}/${PN}"
		-DCUSTOM_BINDIR="${GAMES_BINDIR}"
		-DCUSTOM_DOCDIR="/usr/share/doc/${PF}"
		-DCUSTOM_LOCALEDIR="/usr/share/locale"
		$(usex dedicated "-DBUILD_SERVER=ON -DBUILD_CLIENT=OFF" "$(cmake-utils_use_build server SERVER) -DBUILD_CLIENT=ON")
		$(cmake-utils_use_enable nls GETTEXT)
		$(cmake-utils_use_enable curl CURL)
		$(cmake-utils_use_use luajit LUAJIT)
		$(cmake-utils_use_enable truetype FREETYPE)
		$(cmake-utils_use_enable sound SOUND)
		$(cmake-utils_use_enable leveldb LEVELDB)
		)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	if use server || use dedicated ; then
		newinitd "${FILESDIR}"/minetestserver.initd minetest-server
		newconfd "${T}"/minetestserver.confd minetest-server
	fi

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update

	if ! use dedicated ; then
		elog
		elog "optional dependencies:"
		elog "	games-action/minetest_game (official mod)"
		elog "	games-action/minetest_common (official mod)"
		elog "	games-action/minetest_build (official mod)"
		elog "	games-action/minetest_survival (official mod)"
		elog
	fi

	if use server || use dedicated ; then
		elog
		elog "Configure your server via /etc/conf.d/minetest-server"
		elog "The user \"minetest\" is created with /var/lib/${PN} homedir."
		elog "Default logfile is ~/minetest-server.log"
		elog
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
