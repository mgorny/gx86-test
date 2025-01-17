# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit autotools eutils

DESCRIPTION="Fbi-IMproved is a framebuffer image viewer based on Fbi and inspired from Vim"
HOMEPAGE="http://savannah.nongnu.org/projects/fbi-improved"
SRC_URI="http://download.savannah.gnu.org/releases/fbi-improved/${P/_pre/-trunk}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="aalib dia djvu exif fbcon gif graphicsmagick imagemagick jpeg pdf png postscript readline sdl static svg tiff xfig"

RDEPEND="media-fonts/terminus-font
	aalib? ( media-libs/aalib[slang] )
	dia? ( app-office/dia )
	djvu? ( app-text/djvu )
	exif? ( media-libs/libexif )
	gif? ( <media-libs/giflib-4.2 )
	graphicsmagick? ( media-gfx/graphicsmagick )
	imagemagick? ( || ( media-gfx/graphicsmagick[imagemagick] media-gfx/imagemagick ) )
	jpeg? ( virtual/jpeg )
	pdf? ( app-text/poppler )
	png? ( media-libs/libpng )
	postscript? ( app-text/libspectre )
	readline? ( sys-libs/readline )
	sdl? ( media-libs/libsdl )
	svg? ( media-gfx/inkscape )
	tiff? ( media-libs/tiff )
	xfig? ( media-gfx/xfig )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

S=${WORKDIR}/${P/_pre/-trunk}

src_prepare() {
	epatch "${FILESDIR}"/${P}-automake-1.12.patch \
		"${FILESDIR}"/${P}-nosvn.patch
	if use graphicsmagick ; then
		epatch "${FILESDIR}"/${P}-graphicsmagick.patch
	fi
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable aalib aa) \
		$(use_enable dia) \
		$(use_enable djvu) \
		$(use_enable exif) \
		$(use_enable fbcon framebuffer) \
		$(use_enable gif) \
		$(use_enable graphicsmagick) \
		$(use_enable imagemagick convert) \
		$(use_enable pdf poppler) \
		$(use_enable png) \
		$(use_enable postscript ps) \
		$(use_enable readline) \
		$(use_enable sdl) \
		$(use_enable static) \
		$(use_enable svg inkscape) \
		$(use_enable tiff) \
		$(use_enable xfig) \
		--disable-hardcoded-font \
		--disable-imlib2 \
		--disable-matrices-rendering \
		--disable-xcftopnm \
		--enable-fimrc \
		--enable-history \
		--enable-loader-string-specification \
		--enable-mark-and-dump \
		--enable-output-console \
		--enable-raw-bits-rendering \
		--enable-read-dirs \
		--enable-recursive-dirs \
		--enable-resize-optimizations \
		--enable-scan-consolefonts \
		--enable-screen \
		--enable-scripting \
		--enable-seek-magic \
		--enable-stdin-image-reading \
		--enable-unicode \
		--enable-warnings \
		--enable-windows \
		--with-default-consolefont=/usr/share/consolefonts/ter-114n.psf.gz
}

src_compile() {
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" docdir=/usr/share/doc/${PF} install
}
