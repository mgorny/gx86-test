# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Lightweight text-mode editor"
HOMEPAGE="http://fte.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip
	mirror://sourceforge/${PN}/${P}-common.zip"

LICENSE="|| ( GPL-2 Artistic )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc -sparc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="gpm slang X"

S="${WORKDIR}/${PN}"

RDEPEND=">=sys-libs/ncurses-5.2
	X? (
		x11-libs/libXdmcp
		x11-libs/libXau
		x11-libs/libX11
		x11-libs/libXpm
	)
	gpm? ( >=sys-libs/gpm-1.20 )"
DEPEND="${RDEPEND}
	slang? ( >=sys-libs/slang-2.1.3 )
	app-arch/unzip"

set_targets() {
	export TARGETS=""
	use slang && TARGETS="${TARGETS} s${PN}"
	use X && TARGETS="${TARGETS} x${PN}"

	[[ ${CHOST} == *-linux-gnu* ]] \
		&& TARGETS="${TARGETS} v${PN}" \
		|| TARGETS="${TARGETS} n${PN}"
}

src_prepare() {
	# Do not apply anymore, posibly deprecated. TODO: Check and clean up.
	# epatch "${FILESDIR}"/${PN}-gcc34
	# epatch "${FILESDIR}"/${PN}-new_keyword.patch
	# epatch "${FILESDIR}"/${PN}-slang.patch
	# epatch "${FILESDIR}"/${PN}-interix.patch

	[[ -e /usr/include/linux/keyboard.h ]] && \
		sed /usr/include/linux/keyboard.h -e '/wait.h/d' > src/hacked_keyboard.h

	sed \
		-e "s:<linux/keyboard.h>:\"hacked_keyboard.h\":" \
		-i src/con_linux.cpp || die "sed keyboard"
	sed \
		-e 's:^OPTIMIZE:#&:g' \
		-e '/^LDFLAGS/s:=:+=:g' \
		-e 's:= g++:= $(CXX):g' \
		-i src/${PN}-unix.mak || die "sed CFLAGS, LDFLAGS, CC"
}

src_configure() {
	set_targets
	sed \
		-e "s:@targets@:${TARGETS}:" \
		-e '/^XINCDIR  =/c\XINCDIR  =' \
		-e '/^XLIBDIR  =/c\XLIBDIR  = -lstdc++' \
		-e '/^SINCDIR   =/c\SINCDIR = -I'"${EPREFIX}"'/usr/include/slang' \
		-i src/${PN}-unix.mak || die "sed targets"

	if ! use gpm; then
		sed \
			-e "s:#define USE_GPM://#define USE_GPM:" \
			-i src/con_linux.cpp || die "sed USE_GPM"
		sed \
			-e "s:-lgpm::" \
			-i src/fte-unix.mak || die "sed -lgpm"
	fi
}

src_compile() {
	local os="-DLINUX" # by now the default in makefile
	[[ ${CHOST} == *-interix* ]] && os=

	DEFFLAGS="PREFIX='${EPREFIX}'/usr CONFIGDIR='${EPREFIX}'/usr/share/${PN} \
		DEFAULT_FTE_CONFIG=../config/main.${PN} UOS=${os}"

	set_targets
	emake CXX=$(tc-getCXX) OPTIMIZE="${CXXFLAGS}" ${DEFFLAGS} TARGETS="${TARGETS}" all
}

src_install() {
	local files

	keepdir /etc/${PN}

	into /usr

	set_targets
	files="${TARGETS} c${PN}"

	for i in ${files}; do
		dobin src/$i
	done

	dobin "${FILESDIR}"/${PN}

	dodoc BUGS README TODO
	dohtml doc/*

	insinto /usr/share/${PN}
	doins -r config/*

	rm -rf "${ED}"/usr/share/${PN}/CVS
}

pkg_postinst() {
	ebegin "Compiling configuration"
	cd "${EPREFIX}"/usr/share/${PN} || die "missing configuration dir"
	"${EPREFIX}"/usr/bin/c${PN} main.${PN} "${EPREFIX}"/etc/${PN}/system.${PN}rc
	eend $?
}
