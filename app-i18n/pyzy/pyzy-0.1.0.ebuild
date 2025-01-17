# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit eutils python autotools

PY_DATABASE=${PN}-database-1.0.0
DESCRIPTION="The Chinese PinYin and Bopomofo conversion library"
HOMEPAGE="https://github.com/pyzy"
SRC_URI="https://pyzy.googlecode.com/files/${P}.tar.gz
	https://pyzy.googlecode.com/files/${PY_DATABASE}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boost doc opencc test"

RDEPEND="dev-libs/glib:2
	dev-db/sqlite:3
	sys-apps/util-linux
	boost? ( dev-libs/boost )
	opencc? ( app-i18n/opencc )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

# Currently it fails to build test code
RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-dont-download-dictionary-file.patch
	mv ../db ./data/db/open-phrase/ || die
	python_convert_shebangs 2 "${S}"/data/db/android/create_db.py
	eautoreconf
}

src_configure() {
	econf \
		--enable-db-open-phrase \
		--enable-db-android \
		$(use_enable boost) \
		$(use_enable opencc) \
		$(use_enable test tests)
}

src_install() {
	default
	use doc && dohtml -r docs/html/*
}
