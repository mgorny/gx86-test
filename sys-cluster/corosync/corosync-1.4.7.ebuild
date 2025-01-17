# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit autotools base

MY_TREE="bf8ff17"

DESCRIPTION="OSI Certified implementation of a complete cluster engine"
HOMEPAGE="http://www.corosync.org/"
SRC_URI="https://github.com/corosync/corosync/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="BSD-2 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86 ~x86-fbsd"
IUSE="doc infiniband ssl static-libs"

RDEPEND="!sys-cluster/heartbeat
	ssl? ( dev-libs/nss )
	infiniband? (
		sys-infiniband/libibverbs
		sys-infiniband/librdmacm
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( sys-apps/groff )"

PATCHES=(
	"${FILESDIR}/${PN}-docs.patch"
)

DOCS=( README.recovery README.devmap SECURITY TODO AUTHORS )

S="${WORKDIR}/${PN}-${PN}-${MY_TREE}"

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	# appends lib to localstatedir automatically
	# FIXME: install just shared libs --disable-static does not work
	econf \
		--localstatedir=/var \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable doc) \
		$(use_enable ssl nss) \
		$(use_enable infiniband rdma)
}

src_install() {
	default
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	rm "${D}"/etc/init.d/corosync-notifyd || die

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	keepdir /var/lib/corosync
	use static-libs || rm -rf "${D}"/usr/$(get_libdir)/*.a || die
}
