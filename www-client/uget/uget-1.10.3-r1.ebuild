# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit base autotools

IUSE="aria2 +curl gstreamer hide-temp-files libnotify nls"
if [[ ${PV} == *9999* ]]; then
	inherit git-2
	KEYWORDS=""
	SRC_URI=""
	EGIT_REPO_URI="git://urlget.git.sourceforge.net/gitroot/urlget/uget"
else
	KEYWORDS="~amd64 ~arm ~ppc ~x86"
	SRC_URI="mirror://sourceforge/urlget/${P}.tar.gz"
fi

DESCRIPTION="Download manager using gtk+ and libcurl"
HOMEPAGE="http://www.ugetdm.com"

LICENSE="LGPL-2.1"
SLOT="0"

REQUIRED_USE="|| ( aria2 curl )"

RDEPEND="
	dev-libs/libpcre
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.4:3
	curl? ( >=net-misc/curl-7.10 )
	gstreamer? ( media-libs/gstreamer:0.10 )
	libnotify? ( x11-libs/libnotify )
	"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-ar-hardcoded.patch
	eautoreconf

	if [[ ${PV} == *9999* ]]; then
		intltoolize || die "intltoolize failed"
		eautoreconf
	fi

	# fix the .desktop file for QA
	sed -i 's/Network;FileTransfer/Network;FileTransfer;/g' uget-gtk.desktop
}

src_configure() {
	econf $(use_enable nls) \
		  $(use_enable curl plugin-curl) \
		  $(use_enable aria2 plugin-aria2) \
		  $(use_enable gstreamer) \
		  $(use_enable hide-temp-files hidden) \
		  $(use_enable libnotify notify)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install

	# the build system forgets this :p
	dobin uget-cmd/uget-cmd

	if [[ ${PV} == *9999* ]]; then
		dodoc AUTHORS ChangeLog README
	else
		dodoc AUTHORS ChangeLog NEWS README
	fi
}

pkg_postinst() {
	if use aria2; then
		echo
		elog "You've enabled the aria2 USE flag, so the aria2 plug-in has been"
		elog "built. This allows you to control a local or remote instance of aria2"
		elog "through xmlrpc. To use aria2 locally you have to emerge"
		elog "net-misc/aria2 with the xmlrpc USE enabled manually."
		echo
	fi
}
