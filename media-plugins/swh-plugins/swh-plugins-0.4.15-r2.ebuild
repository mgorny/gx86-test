# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils autotools

DESCRIPTION="Large collection of LADSPA audio plugins/effects"
HOMEPAGE="http://plugin.org.uk"
SRC_URI="http://plugin.org.uk/releases/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="3dnow nls sse"

RDEPEND="media-libs/ladspa-sdk
	media-sound/gsm
	>=sci-libs/fftw-3"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-pic.patch"
	epatch "${FILESDIR}/${P}-plugindir.patch"
	epatch "${FILESDIR}/${P}-riceitdown.patch"
	epatch "${FILESDIR}/${P}-gettext.patch"
	epatch "${FILESDIR}/${P}-x86-asm-optional.patch"
	epatch "${FILESDIR}/${P}-glibc-2.10.patch"

	# Use system libgsm, bug #252890
	rm -rf gsm
	epatch "${FILESDIR}/${P}-system_gsm.patch"

	# This is to update gettext macros, otherwise they are incompatible with
	# recent libtools, bug #231767
	autopoint -f || die

	# it doesn't get updated otherwise
	rm -f missing

	# Fix build with automake 1.13
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.in || die

	eautoreconf
	elibtoolize
}

src_compile() {
	econf ${myconf} \
		$(use_enable sse) \
		$(use_enable 3dnow) \
		$(use_enable nls) \
		$(use_enable userland_Darwin darwin) \
		--enable-fast-install \
		--disable-dependency-tracking || die "econf failed"
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog README TODO
}

pkg_postinst() {
	ewarn "WARNING: You have to be careful when using the"
	ewarn "swh plugins. Be sure to lower your sound volume"
	ewarn "and then play around a bit with the plugins so"
	ewarn "you get a feeling for it. Otherwise your speakers"
	ewarn "won't like that."
}
