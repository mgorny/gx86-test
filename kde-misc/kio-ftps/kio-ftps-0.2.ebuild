# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit kde4-base

DESCRIPTION="KDE ftps KIO slave"
HOMEPAGE="http://kasablanca.berlios.de/kio-ftps/"
SRC_URI="mirror://berlios/kasablanca/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

# This is just for some app we can use kio-ftps with
RDEPEND="|| (
	$(add_kdebase_dep konqueror)
	$(add_kdebase_dep dolphin)
)"

S="${WORKDIR}/${PN}"

src_prepare() {
	# remove all temp files
	rm -rf *~
	# fix linking
	sed -i \
		-e "s:\${KDE4_KDECORE_LIBS}:\${KDE4_KIO_LIBS}:g" \
		CMakeLists.txt || die "sed linking failed"
}
