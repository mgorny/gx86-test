# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit games

DESCRIPTION="Unreal Tournament 2003 Linux Dedicated Server"
HOMEPAGE="http://www.ut2003.com/"
SRC_URI="http://games.gci.net/pub/UT2003/ut2003-lnxded-${PV}.tar.bz2
	mirror://3dgamers/unrealtourn2/ut2003-lnxded-${PV}.tar.bz2
	http://downloads.unrealadmin.org/UT2003/Server/Linux/ut2003-lnxded-${PV}.tar.bz2
	mirror://gentoo/UT2003CrashFix.zip
	http://download.factoryunreal.com/mirror/UT2003CrashFix.zip"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror strip"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

QA_PREBUILT="${dir:1}/System/*"

src_unpack() {
	unpack ut2003-lnxded-${PV}.tar.bz2 \
		|| die "unpacking dedicated server files."
	unzip "${DISTDIR}"/UT2003CrashFix.zip \
		|| die "unpacking crash-fix"
}

src_install() {
	einfo "This will take a while ... go get a pizza or something"

	dodir "${dir}"
	mv "${S}"/ut2003_dedicated/* "${Ddir}"

	# Here we apply DrSiN's crash patch
	cp "${S}"/CrashFix/System/crashfix.u "${Ddir}"/System

	ed "${Ddir}"/System/Default.ini >/dev/null 2>&1 <<EOT
$
?Engine.GameInfo?
a
AccessControlClass=crashfix.iaccesscontrolini
.
w
q
EOT

	# Here we apply fix for bug #54726
	dosed "s:UplinkToGamespy=True:UplinkToGamespy=False:" \
		"${dir}"/System/Default.ini

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	ewarn "NOTE: To have your server authenticate properly, you"
	ewarn "      MUST visit the following site and request a key."
	ewarn "http://ut2003.epicgames.com/ut2003server/cdkey.php"
	echo
	ewarn "If you are not installing for the first time and you plan on running"
	ewarn "a server, you will probably need to edit your"
	ewarn "~/.ut2003/System/UT2003.ini file and add a line that says"
	ewarn "AccessControlClass=crashfix.iaccesscontrolini to your"
	ewarn "[Engine.GameInfo] section to close a security issue."
}
