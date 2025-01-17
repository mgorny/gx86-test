# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit bash-completion-r1 eutils

DESCRIPTION="Console ftp client with a lot of nifty features"
HOMEPAGE="http://www.yafc-ftp.com/"
SRC_URI="http://www.yafc-ftp.com/upload/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"
IUSE="ipv6 readline kerberos socks5 ssh"

DEPEND="dev-libs/openssl:0
	readline? ( >=sys-libs/readline-6 )
	kerberos? ( virtual/krb5 )
	socks5? ( net-proxy/dante )
	ssh? ( net-libs/libssh )"
RDEPEND="${DEPEND}"

DOCS=( BUGS NEWS README THANKS TODO )

src_prepare() {
	epatch_user
}

src_configure() {
	export ac_cv_ipv6=$(usex ipv6)
	econf \
		$(use_with readline readline /usr) \
		$(use_with socks5 socks /usr) \
		$(use_with socks5 socks5 /usr) \
		$(use_with kerberos krb5) \
		$(use_with ssh) \
		--with-bash-completion="$(get_bashcompdir)" \
		--without-krb4
}

src_install() {
	default
	dodoc -r samples
}
