# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

DESCRIPTION="implementation of rpcsec_gss (RFC 2203) for secure rpc communication"
HOMEPAGE="http://www.citi.umich.edu/projects/nfsv4/linux/"
SRC_URI="http://www.citi.umich.edu/projects/nfsv4/linux/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

RDEPEND="net-libs/libgssglue"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	# No need to install static libraries, as it uses non-static dependencies
	econf --disable-static
}

src_install() {
	emake install DESTDIR="${D}" || die
	find "${D}" -name '*.la' -delete || die

	dodoc AUTHORS ChangeLog NEWS README
}
