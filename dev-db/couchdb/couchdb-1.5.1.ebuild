# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit eutils multilib pax-utils user

DESCRIPTION="Apache CouchDB is a distributed, fault-tolerant and schema-free document-oriented database"
HOMEPAGE="http://couchdb.apache.org/"
SRC_URI="mirror://apache/couchdb/source/${PV}/apache-${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="selinux test"

RDEPEND=">=dev-libs/icu-4.3.1:=
		<dev-lang/erlang-17[ssl]
		>=dev-libs/openssl-0.9.8j:0
		>=net-misc/curl-7.18.2
		<dev-lang/spidermonkey-1.8.7
		selinux? ( sec-policy/selinux-couchdb )"

DEPEND="${RDEPEND}"
RESTRICT=test

S="${WORKDIR}/apache-${P}"

pkg_setup() {
	enewgroup couchdb
	enewuser couchdb -1 -1 /var/lib/couchdb couchdb
}

src_prepare() {
	sed -i ./src/couchdb/priv/Makefile.* -e 's|-Werror||g'
}

src_configure() {
	econf \
		--with-erlang=/usr/lib/erlang/usr/include \
		--localstatedir=/var \
		--with-js-lib=/usr/lib
	# bug 296609, upstream bug #COUCHDB-621
	sed -e "s#localdocdir = /usr/share/doc/couchdb#localdocdir = /usr/share/doc/${PF}#" -i Makefile || die "sed failed"
}

src_compile() {
	emake
	# bug 442616
	pax-mark mr src/couchdb/priv/couchjs
}

src_test() {
	emake distcheck
}

src_install() {
	emake DESTDIR="${D}" install

	fowners couchdb:couchdb \
		/var/lib/couchdb \
		/var/log/couchdb

	for f in "${D}"/etc/couchdb/*.ini ; do
		fowners root:couchdb "${f#${D}}"
		fperms 660 "${f#${D}}"
	done
	fperms 664 /etc/couchdb/default.ini

	newinitd "${FILESDIR}/couchdb.init-4" couchdb
	newconfd "${FILESDIR}/couchdb.conf-2" couchdb

	sed -i -e "s:LIBDIR:$(get_libdir):" "${D}/etc/conf.d/couchdb"
}
