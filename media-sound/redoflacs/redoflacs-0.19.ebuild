# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
inherit readme.gentoo vcs-snapshot

DESCRIPTION="Bash commandline flac compressor, verifier, organizer, analyzer, retagger"
HOMEPAGE="https://github.com/sirjaren/redoflacs"
SRC_URI="https://github.com/sirjaren/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-shells/bash-4
	media-libs/flac
	sys-apps/coreutils"

src_install() {
	exeinto /usr/bin
	doexe redoflacs
	readme.gentoo_create_doc
}
