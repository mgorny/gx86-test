# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit eutils multilib qt4-r2 readme.gentoo udev user

DESCRIPTION="Use Fingerprint Devices with Linux"
HOMEPAGE="http://www.n-view.net/Appliance/fingerprint/"
SRC_URI="http://ullrich-online.cc/nview/Appliance/${PN%-gui}/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+upekbsapi"

RDEPEND="app-crypt/qca
	app-crypt/qca-ossl
	sys-auth/libfprint
	sys-auth/polkit-qt
	sys-libs/pam
	x11-libs/libfakekey
	dev-qt/qtcore:4
	!sys-auth/thinkfinger"
DEPEND="${RDEPEND}"

QA_SONAME="/usr/lib/libbsapi.so.* /usr/lib64/libbsapi.so.*"
QA_PRESTRIPPED="/usr/lib/libbsapi.so.* /usr/lib64/libbsapi.so.*"
QA_FLAGS_IGNORED="/usr/lib/libbsapi.so.* /usr/lib64/libbsapi.so.*"

src_prepare() {
	sed -e '/Icon=/s:=.*:=Fingerprint:' \
		-i bin/${PN}/${PN}.desktop || die
	sed -e "s:/etc/udev/rules.d:\"$(get_udevdir)\"/rules.d:g" \
		-i bin/${PN%-gui}-helper/${PN%-gui}-helper.pro || die
	sed -e 's:GROUP="plugdev":GROUP="fingerprint":' \
		-i bin/fingerprint-helper/92-fingerprint-gui-uinput.rules \
		-i upek/91-fingerprint-gui-upek.rules || die
}

src_configure() {
	eqmake4 \
		PREFIX="${EROOT}"usr \
		LIB="$(get_libdir)" \
		LIBEXEC=libexec \
		LIBPOLKIT_QT=LIBPOLKIT_QT_1_1
}

src_install() {
	export INSTALL_ROOT="${D}" #submakes need it as well, re-install fails otherwise.
	emake install
	rm -r "${ED}"/usr/share/doc/${PN} || die
	if use upekbsapi ; then
		use amd64 && dolib.so upek/lib64/libbsapi.so*
		use x86 && dolib.so upek/lib/libbsapi.so*
		udev_dorules upek/91-fingerprint-gui-upek.rules
		insinto /etc
		doins upek/upek.cfg
		#dodir /var/upek_data
		#fowners root:plugdev /var/upek_data
		#fperms 0775 /var/upek_data
	fi
	doicon src/res/Fingerprint.png

	dodoc CHANGELOG README
	dohtml doc/*

	readme.gentoo_src_install
}

pkg_preinst() {
	enewgroup fingerprint
}

FORCE_PRINT_ELOG=1
DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="Please take a thorough look a the Install-step-by-step.html
in /usr/share/doc/${PF} for integration with pam/polkit/...
Hint: You may want
   auth        sufficient  pam_fingerprint-gui.so
in /etc/pam.d/system-auth

There are udev rules to enforce group fingerprint on the reader device
Please put yourself in that group and re-trigger the udev rules."
