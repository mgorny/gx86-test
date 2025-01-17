# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit multilib versionator

LICENSE="GPL-2"

DESCRIPTION="mirror/replicate block-devices across a network-connection"
SRC_URI="http://oss.linbit.com/drbd/$(get_version_component_range 1-2 ${PV})/${P}.tar.gz"
HOMEPAGE="http://www.drbd.org"

KEYWORDS="amd64 x86"
IUSE="bash-completion heartbeat pacemaker +udev xen"
SLOT="0"

src_prepare() {
	# respect LDFLAGS
	sed -i -e "s/\$(CC) -o/\$(CC) \$(LDFLAGS) -o/" user/Makefile.in || die
	# respect multilib
	sed -i -e "s:/lib/:/$(get_libdir)/:g" \
		scripts/{Makefile.in,global_common.conf,drbd.conf.example} || die
	# correct install paths
	sed -i -e "s:\$(sysconfdir)/bash_completion.d:/usr/share/bash-completion:" \
		scripts/Makefile.in || die
}

src_configure() {
	econf \
		--localstatedir=/var \
		--with-utils \
		--without-km \
		--without-rgmanager \
		$(use_with udev) \
		$(use_with xen) \
		$(use_with pacemaker) \
		$(use_with heartbeat) \
		$(use_with bash-completion bashcompletion) \
		--with-distro=gentoo
}

src_compile() {
	# only compile the tools
	emake OPTFLAGS="${CFLAGS}" tools || die
}

src_install() {
	# only install the tools
	emake DESTDIR="${D}" install-tools || die
	dodoc README ChangeLog || die

	# install our own init script
	newinitd "${FILESDIR}"/${PN}-8.0.rc ${PN} || die

	# it doesnt make sense to install a default conf in /etc,
	# so we put it to the docs
	rm -f "${D}"/etc/drbd.conf
	dodoc scripts/drbd.conf || die
}

pkg_postinst() {
	einfo
	einfo "Please copy and gunzip the configuration file"
	einfo "from /usr/share/doc/${PF}/drbd.conf.bz2 to /etc"
	einfo "and edit it to your needs. Helpful commands:"
	einfo "man 5 drbd.conf"
	einfo "man 8 drbdsetup"
	einfo "man 8 drbdadm"
	einfo "man 8 drbddisk"
	einfo "man 8 drbdmeta"
	einfo

	elog "Remember to enable drbd support in kernel."
	elog "Or alternatively emerge sys-cluster/drbd-kernel package."
}
