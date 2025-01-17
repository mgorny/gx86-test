# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 )
PYTHON_REQ_USE="ncurses"
inherit distutils-r1 prefix

DESCRIPTION="Curses based utility to parse the contents of elogs created by Portage"
HOMEPAGE="https://github.com/gentoo/elogv"
SRC_URI="https://github.com/gentoo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ~ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="linguas_de linguas_es linguas_it linguas_pl"

DOCS=( README )

src_install() {
	distutils-r1_src_install

	# unset LINGUAS => install all languages
	# empty LINGUAS => install none
	local i
	if [[ -n "${LINGUAS+x}" ]] ; then
		for i in $(ls "${ED}"/usr/share/locale/) ; do
			if ! has ${i} ${LINGUAS} ; then
				rm -rf "${ED}"/usr/share/{locale,man}/${i}
			fi
		done
	fi
}

pkg_postinst() {
	elog "Optional dependencies:"
	elog "  dev-python/pyliblzma (for xz compressed elog files)"
	elog
	elog "In order to use this software, you need to activate"
	elog "Portage's elog features.  Required is"
	elog "		 PORTAGE_ELOG_SYSTEM=\"save\" "
	elog "and at least one out of "
	elog "		 PORTAGE_ELOG_CLASSES=\"warn error info log qa\""
	elog "More information on the elog system can be found"
	elog "in ${EPREFIX}/etc/make.conf.example"
	elog
	elog "To operate properly this software needs the directory"
	elog "${PORT_LOGDIR:-${EPREFIX}/var/log/portage}/elog created, belonging to group portage."
	elog "To start the software as a user, add yourself to the portage"
	elog "group."
	elog
}
