# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=3

PYTHON_USE_WITH="sqlite"
PYTHON_DEPEND="2:2.6"
PYTHON_MODNAME=translate

inherit distutils python

DESCRIPTION="Toolkit to convert between many translation formats"
HOMEPAGE="http://translate.sourceforge.net"
SRC_URI="mirror://sourceforge/translate/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc +html +ical +ini +subtitles"

RDEPEND="
	app-text/iso-codes
	dev-python/lxml
	dev-python/python-levenshtein
	sys-devel/gettext
	html? ( dev-python/utidylib )
	ical? ( dev-python/vobject )
	ini? ( dev-python/iniparse )
"
DEPEND="${RDEPEND}"

src_install() {
	local filename binary

	dohtml -r translate/doc/{index.html,README,user} || die
	use doc && { dohtml -r translate/doc/api/* || die ; }
	rm -Rf translate/doc || die

	distutils_src_install

	if ! use html; then
		rm "${ED}"/usr/bin/html2po || die
		rm "${ED}"/usr/bin/po2html || die
	fi
	if ! use ical; then
		rm "${ED}"/usr/bin/ical2po || die
		rm "${ED}"/usr/bin/po2ical || die
	fi
	if ! use ini; then
		rm "${ED}"/usr/bin/ini2po || die
		rm "${ED}"/usr/bin/po2ini || die
	fi
	if ! use subtitles; then
		rm "${ED}"/usr/bin/sub2po || die
		rm "${ED}"/usr/bin/po2sub || die
	fi

	einfo "Generating man pages..."
	for binary in "${ED}"/usr/bin/*; do
		filename=$(basename "${binary}")
		PYTHONPATH=${WORKDIR}/${PF}:${PYTHONPATH}

		if  ${file} --man > "${T}/${filename}.1" 2> /dev/null; then
			doman "${T}/${filename}.1" || die
		fi
	done
}
