# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit eutils unpacker

SRC_URI_BASE="https://spideroak.com/getbuild?platform=ubuntu"

DESCRIPTION="An easy, secure and consolidated free online backup, storage, access and sharing system"
HOMEPAGE="https://spideroak.com"
SRC_URI="x86? ( ${SRC_URI_BASE}&arch=i386&version=${PV} -> ${P}_x86.deb )
	amd64? ( ${SRC_URI_BASE}&arch=x86_64&version=${PV} -> ${P}_amd64.deb )"
RESTRICT="mirror strip"

LICENSE="spideroak"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus headless"

DEPEND="dev-util/patchelf"
RDEPEND="
	app-crypt/mit-krb5[keyutils]
	dbus? ( sys-apps/dbus )
	!headless? (
		media-libs/fontconfig
		media-libs/freetype:2
		dev-libs/glib:2
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXmu
		x11-libs/libXrender
		x11-libs/libXt
	)
"

S=${WORKDIR}

QA_PREBUILT="*"

src_prepare() {
	use headless && epatch "${FILESDIR}"/${PN}-5.0.1-headless.patch

	# Set RPATH for preserve-libs handling (bug #400979).
	cd "${S}/opt/SpiderOak/lib" || die
	local x
	for x in `find` ; do
		# Use \x7fELF header to separate ELF executables and libraries
		[[ -f ${x} && $(od -t x1 -N 4 "${x}") == *"7f 45 4c 46"* ]] || continue
		patchelf --set-rpath '$ORIGIN' "${x}" || \
			die "patchelf failed on ${x}"
	done
}

src_install() {
	#install the wrapper script
	exeinto /usr/bin
	doexe usr/bin/SpiderOak

	# inotify_dir_watcher needs to be marked executable, bug #453266
	#chmod a+rx opt/SpiderOak/lib/inotify_dir_watcher

	#install the executable
	exeinto /opt/SpiderOak/lib
	doexe opt/SpiderOak/lib/SpiderOak
	doexe opt/SpiderOak/lib/inotify_dir_watcher
	rm -f opt/SpiderOak/lib/{SpiderOak,inotify_dir_watcher}

	#install the prebundled libraries
	insinto /opt/SpiderOak
	doins -r opt/SpiderOak/lib

	#install the config files
	use dbus || rm -rf etc/dbus-1
	insinto /
	doins -r etc

	#install the manpage
	doman usr/share/man/man1/SpiderOak.1.gz

	if ! use headless ; then
		domenu usr/share/applications/spideroak.desktop
		doicon usr/share/pixmaps/SpiderOak.png
	fi
}

pkg_postinst() {
	if use headless; then
		einfo "For instructions on running SpiderOak without a GUI, please read the FAQ:"
		einfo "  https://spideroak.com/faq/questions/31/how_do_i_install_spideroak_on_a_headless_linux_server/"
		einfo "  https://spideroak.com/faq/questions/67/how_can_i_use_spideroak_from_the_commandline/"
	fi
}
