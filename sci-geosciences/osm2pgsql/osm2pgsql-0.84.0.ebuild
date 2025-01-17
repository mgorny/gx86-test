# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit autotools

DESCRIPTION="Converts OSM data to SQL and insert into PostgreSQL db"
HOMEPAGE="http://wiki.openstreetmap.org/wiki/Osm2pgsql"
SRC_URI="https://github.com/openstreetmap/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lua +pbf"

DEPEND="
	app-arch/bzip2
	dev-db/postgresql-base
	dev-libs/libxml2:2
	sci-libs/geos
	sci-libs/proj
	sys-libs/zlib
	lua? ( dev-lang/lua )
	pbf? ( dev-libs/protobuf-c )
"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}
