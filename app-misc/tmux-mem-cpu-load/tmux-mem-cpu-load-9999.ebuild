# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"

inherit cmake-utils

IUSE=""
if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI=${EGIT_REPO_URI:-"git://github.com/thewtex/tmux-mem-cpu-load.git"}
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/thewtex/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="CPU, RAM memory, and load monitor for use with tmux"
HOMEPAGE="http://github.com/thewtex/tmux-mem-cpu-load/"

LICENSE="Apache-2.0"
SLOT="0"

src_install() {
	cmake-utils_src_install
	dodoc README.rst || die
}
