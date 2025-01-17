# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit base vim-doc

DESCRIPTION="Console file manager with vi(m)-like keybindings"
HOMEPAGE="http://vifm.sourceforge.net/"
SRC_URI="mirror://sourceforge/vifm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~s390 ~x86"
IUSE="X +extended-keys gtk +magic vim vim-syntax"

DEPEND="
	>=sys-libs/ncurses-5.7-r7
	magic? ( sys-apps/file )
	gtk? ( x11-libs/gtk+:2 )
	X? ( x11-libs/libX11 )
"
RDEPEND="
	${DEPEND}
	vim? ( || ( app-editors/vim app-editors/gvim ) )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
"

DOCS=( AUTHORS FAQ NEWS README TODO )

src_configure() {
	econf \
		$(use_enable extended-keys) \
		$(use_with magic libmagic) \
		$(use_with gtk) \
		$(use_with X X11)
}

src_install() {
	base_src_install

	if use vim; then
		local t
		for t in doc plugin; do
			insinto /usr/share/vim/vimfiles/"${t}"
			doins "${S}"/data/vim/"${t}"/"${PN}".*
		done
	fi

	if use vim-syntax; then
		local t
		for t in ftdetect ftplugin syntax; do
			insinto /usr/share/vim/vimfiles/"${t}"
			doins "${S}"/data/vim/"${t}"/"${PN}".vim
		done
	fi
}

pkg_postinst() {
	if use vim; then
		update_vim_helptags

		if [[ -n ${REPLACING_VERSIONS} ]]; then
			elog
			elog "You don't need to copy or link any files for"
			elog "  the vim plugin and documentation to work anymore."
			elog "If you copied any vifm files to ~/.vim/ manually"
			elog "  in earlier vifm versions, please delete them."
		fi
		elog
		elog "To use vim in vifm to view the documentation"
		elog "  edit ~/.vifm/vifmrc and set vimhelp instead of novimhelp"
		elog
	fi
}

pkg_postrm() {
	use vim && update_vim_helptags
}
