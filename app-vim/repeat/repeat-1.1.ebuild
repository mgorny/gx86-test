# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit vim-plugin

MY_PN="vim-repeat"
MY_P=${MY_PN}-${PV}

DESCRIPTION="vim plugin: use the repeat command \".\" with plugin maps"
HOMEPAGE="https://github.com/tpope/vim-repeat/ http://www.vim.org/scripts/script.php?script_id=2136"
SRC_URI="https://github.com/tpope/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="amd64 x86"

S=${WORKDIR}/${MY_P}

src_prepare() {
	rm *.markdown || die
}
