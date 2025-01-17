# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PLOCALES="ar ast be bg bn bs ca cs da de el en_AU en_GB eo es et eu fa fi fo fr gl he hi hr hu hy ia id it ja ko ku ky lt ms
my nb nds nl pl pt_BR pt ro ru se si sk sl sr sv ta te th tr ug uk uz vi zh_CN zh_TW"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 eutils l10n

DESCRIPTION="Clean junk to free disk space and to maintain privacy"
HOMEPAGE="http://bleachbit.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="dev-python/pygtk:2[$PYTHON_USEDEP]"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

DOCS=( README )

python_prepare_all() {
	rem_locale() {
		rm "po/${1}.po" || die "removing of ${1}.po failed"
	}

	l10n_find_plocales_changes po "" ".po"
	l10n_for_each_disabled_locale_do rem_locale

	addpredict /root/.gnome2 #401981

	# warning: key "Encoding" in group "Desktop Entry" is deprecated
	sed -i -e '/Encoding/d' ${PN}.desktop || die

	# choose correct Python implementation, bug #465254
	sed -i -e 's/python/$(PYTHON)/g' po/Makefile || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use nls && emake -C po
}

python_install_all() {
	distutils-r1_python_install_all
	use nls && emake -C po DESTDIR="${D}" install

	# http://bugs.gentoo.org/388999
	insinto /usr/share/${PN}/cleaners
	doins cleaners/*.xml

	newbin ${PN}.py ${PN}
	python_replicate_script "${D}/usr/bin/${PN}"

	doicon ${PN}.png
	domenu ${PN}.desktop
}
