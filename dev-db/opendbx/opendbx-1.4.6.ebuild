# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit flag-o-matic multilib

DESCRIPTION="OpenDBX - A database abstraction layer"
HOMEPAGE="http://www.linuxnetworks.de/doc/index.php/OpenDBX"
SRC_URI="http://www.linuxnetworks.de/opendbx/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bindist firebird +mysql oracle postgres sqlite sqlite3"

DEPEND="mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )
	sqlite? ( <dev-db/sqlite-3 )
	sqlite3? ( =dev-db/sqlite-3* )
	oracle? ( dev-db/oracle-instantclient-basic )
	firebird? ( dev-db/firebird )"
RDEPEND="${DEPEND}"

REQUIRED_USE="bindist? ( !firebird )"

pkg_setup() {
	if ! ( use firebird || use mysql || use oracle || use postgres || use sqlite || use sqlite3 )
	then
		ewarn "You should enable at least one of the following USE flags:"
		ewarn "firebird, mysql, oracle, postgres, sqlite or sqlite3"
	fi

	if use oracle && [[ ! -d ${ORACLE_HOME} ]]
	then
		die "Oracle support requested, but ORACLE_HOME not set to a valid directory!"
	fi

	use mysql && append-cppflags -I/usr/include/mysql
	use firebird && append-cppflags -I/opt/firebird/include
	use oracle && append-ldflags -L"${ORACLE_HOME}"/lib
}

src_configure() {
	local backends=""

	use !bindist && use firebird && backends="${backends} firebird"
	use mysql && backends="${backends} mysql"
	use oracle && backends="${backends} oracle"
	use postgres && backends="${backends} pgsql"
	use sqlite && backends="${backends} sqlite"
	use sqlite3 && backends="${backends} sqlite3"

	econf --with-backends="${backends}" || die "econf failed"
}

src_compile() {
	# bug #322221
	emake -j1 || die "emake failed"
}

src_install() {
	emake -j1 install DESTDIR="${D}" || die "make install failed"
	dodoc AUTHORS ChangeLog README

	rm -f "${D}"/usr/$(get_libdir)/opendbx/*.{a,la}
}
